//
//  DataManager.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

@MainActor
class DataManager {
    @AppStorage("userLoggedIn") var userLoggedIn: Bool = false
    @AppStorage("showWelcomeView") var showWelcomeView: Bool = true
    static let shared = DataManager()
    
    let db = Firestore.firestore()
    
    func checkUserDataComplete(completion: @escaping (Bool) -> Void) {
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
    
    func createUser(firstName: String, lastName: String, username: String, birthday: Date, context: ModelContext) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let newUser = User(id: userID, firstName: firstName, lastName: lastName, username: username, dateJoined: Date(), birthday: birthday)
        context.insert(newUser)
        print("New User saved to SwiftData")
        
        let userData = newUser.toDictionary()
        db.collection("users").document(userID).setData(userData)
        print("New User saved to Firebase")
                
        userLoggedIn = true
        showWelcomeView = true
    }
    
    func downloadUserData(context: ModelContext) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                if let data = document.data(),
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String,
                   let userName = data["username"] as? String,
                   let dateJoind = data["dateJoined"] as? Timestamp,
                   let birthday = data["birthday"] as? Timestamp {
                    let newUser = User(id: userID, firstName: firstName, lastName: lastName, username: userName, dateJoined: dateJoind.dateValue(), birthday: birthday.dateValue())
                    context.insert(newUser)
                    print("User data downloaded from Firebase")
                    // Download other data
                    self.userLoggedIn = true
                }
            }
        }
    }
    
    func fetchAllUsernames(completion: @escaping ([String]) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching usernames: \(error.localizedDescription)")
                completion([])
                return
            }
            
            let usernames = snapshot?.documents.compactMap { $0.data()["username"] as? String } ?? []
            print("Usernames fetched from firebase.")
            completion(usernames)
        }
    }
}
