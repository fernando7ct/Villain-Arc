//
//  AuthManager.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func signIn(email: String, password: String) {
        // Attempts to sign up user, if fails then its either the email already exists which we handle, or
        // another error which shouldn't happen
        Auth.auth().createUser(withEmail: email, password: password) { signUpResult, signUpError in
            if let signUpError = signUpError {
                let signUpErrorCode = (signUpError as NSError).code
                if signUpErrorCode == AuthErrorCode.emailAlreadyInUse.rawValue {
                    // Attempts to sign in user, if fails then its either password is incorrect which we handle, or
                    // another error which shouldn't happen
                    Auth.auth().signIn(withEmail: email, password: password) { logInResult, signInError in
                        if let signInError = signInError {
                            let signInErrorCode = (signInError as NSError).code
                            if signInErrorCode == 17004 {
                                // Signal back to view that password is incorrect
                                print("Wrong password!")
                            } else {
                                print(signInError.localizedDescription)
                            }
                        } else {
                            // Sign in is successfull, now we need to check if their info is complete
                            // If it is complete then we download all the data, creating user first.
                            // If not complete, then we create the user object as well but then take them to profile questions
                            print("Successfully signed in!")
                        }
                    }
                } else {
                    print(signUpError.localizedDescription)
                }
            } else {
                // If successfull, then create the new user object, and then go to profile questions
                print("Successfully signed up!")
            }
        }
    }
}
