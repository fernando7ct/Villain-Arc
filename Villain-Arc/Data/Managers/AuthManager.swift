//
//  AuthManager.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices

enum AuthenticationResult {
    case newUser, existingUser, error
}

@MainActor
class AuthManager: NSObject {
    static let shared = AuthManager()
    
    private var currentNonce: String?
    private var completionHandler: ((AuthenticationResult) -> Void)? = nil
    
    
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
    
    func signInApple(completion: @escaping (AuthenticationResult) -> Void) async {
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
            DataManager.shared.checkUserDataComplete { complete in
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
