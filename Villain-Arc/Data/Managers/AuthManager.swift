//
//  AuthManager.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
import CryptoKit
import AuthenticationServices

enum AuthenticationResult {
    case wrongPassword, newUser, existingUser, error
}

@MainActor
class AuthManager: NSObject {
    static let shared = AuthManager()
    
    let db = Firestore.firestore()
    
    private var currentNonce: String?
    private var completionHandler: ((AuthenticationResult) -> Void)? = nil
    
    func signIn(email: String, password: String, completion: @escaping (AuthenticationResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { signUpResult, signUpError in
            if let signUpError = signUpError {
                let signUpErrorCode = (signUpError as NSError).code
                if signUpErrorCode == AuthErrorCode.emailAlreadyInUse.rawValue {
                    Auth.auth().signIn(withEmail: email, password: password) { logInResult, signInError in
                        if let signInError = signInError {
                            let signInErrorCode = (signInError as NSError).code
                            if signInErrorCode == 17004 {
                                print("Wrong password")
                                completion(.wrongPassword)
                            } else {
                                print(signInError.localizedDescription)
                                completion(.error)
                            }
                        } else {
                            self.checkUserDataComplete { complete in
                                if complete {
                                    print("Successfully signed in and user data is complete")
                                    completion(.existingUser)
                                } else {
                                    print("Successfully signed in but user data is not complete")
                                    completion(.newUser)
                                }
                            }
                        }
                    }
                } else {
                    print(signUpError.localizedDescription)
                    completion(.error)
                }
            } else {
                print("Successfully signed up")
                completion(.newUser)
            }
        }
    }
    
    func signInGoogle(completion: @escaping (AuthenticationResult) -> Void) async throws {
        guard let topVC = UIApplication.topViewController() else {
            completion(.error)
            return
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            completion(.error)
            return
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        self.signInWith(credential: credential, completion: completion)
    }
    
    
    func signInApple(completion: @escaping (AuthenticationResult) -> Void) async throws {
        startSignInWithAppleFlow(completion: completion)
    }
    
    func startSignInWithAppleFlow(completion: @escaping (AuthenticationResult) -> Void) {
        guard let topVC = UIApplication.topViewController() else {
            completion(.error)
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    func signInWith(credential: AuthCredential, completion: @escaping (AuthenticationResult) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Error signing in with \(credential): \(error.localizedDescription)")
                completion(.error)
            }
            self.checkUserDataComplete { complete in
                if complete {
                    print("Successfully signed in with \(credential) and user data complete.")
                    completion(.existingUser)
                } else {
                    print("Successfully signed in with \(credential) but user data not complete.")
                    completion(.newUser)
                }
            }
        }
    }
    
    private func checkUserDataComplete(completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data(),
                   let _ = data["firstName"] as? String,
                   let _ = data["lastName"] as? String,
                   let _ = data["username"] as? String,
                   let _ = data["dateJoined"] as? Timestamp,
                   let _ = data["birthday"] as? Timestamp {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                completionHandler?(.error)
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                completionHandler?(.error)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                completionHandler?(.error)
                return
            }
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            signInWith(credential: credential) { result in
                self.completionHandler?(result)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        completionHandler?(.error)
    }
}

extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
