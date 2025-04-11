//
//  AuthManager.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthenticationResult {
    case wrongPassword, newUser, existingUser, error
}

class AuthManager {
    static let shared = AuthManager()
    
    let db = Firestore.firestore()
    
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
                            self.checkUserDataComplete { result in
                                if result {
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
}
