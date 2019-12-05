//
//  User.swift
//  Message
//
//  Created by Minh Tâm on 11/21/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import FirebaseAuth

enum SenderType {
    case send
    case receive
}

enum Gender {
    case male
    case female
}

struct User {
    var uid: String = ""
    var email: String = ""
    var password: String = ""
    var userName: String = ""
    var birthday: Date?
    var gender: Gender = .male
    var typeSender: SenderType = .receive
    var image: String = ""
    var roomArray: [String] = [""]
    var status: String = ""
    var isSelected: Bool = false
}
