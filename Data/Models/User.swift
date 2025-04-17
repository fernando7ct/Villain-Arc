//
//  User.swift
//  Villain-Arc
//
//  Created by Fernando Caudillo Tafoya on 4/11/25.
//

import Foundation
import SwiftData

@Model
class User {
    var id: String = UUID().uuidString
    var firstName: String = ""
    var lastName: String = ""
    var username: String = ""
    var dateJoined: Date = Date()
    var birthday: Date = Date()
    
    init(id: String, firstName: String, lastName: String, username: String, dateJoined: Date, birthday: Date) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.dateJoined = dateJoined
        self.birthday = birthday
    }
}

extension User {
    func toDictionary() -> [String: Any] {
        return [
            "id": self.id,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "username": self.username,
            "dateJoined": self.dateJoined,
            "birthday": self.birthday
        ]
    }
}
