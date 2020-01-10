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
    case unknown
}

enum Gender: String {
    case male = "Nam"
    case female = "Nữ"
    case unknown = "Không xác định"
}

struct User {
    var uid: String = ""
    var email: String = ""
    var password: String = ""
    var userName: String = ""
    var birthday: Date?
    var gender: Gender = .unknown
    var senderType: SenderType = .unknown
    var image: String = ""
    var roomArray: [String] = [""]
    var isSelected: Bool = false
    var numberPhone: String = ""
    
    init(userName: String, image: String, email: String, uid: String, senderType: SenderType, gender: Gender, roomArray: [String], numberPhone: String) {
        self.userName = userName
        self.image = image
        self.email = email
        self.uid = uid
        self.roomArray = roomArray
        self.senderType = senderType
        self.gender = gender
        self.numberPhone = numberPhone
    }
    
    static func map(uid: String, dictionary: [String: Any]) -> User {
        let currentUser = Auth.auth().currentUser
        let userName = dictionary["userName"] as? String ?? ""
        let email = dictionary["email"] as? String ?? ""
        let image = dictionary["image"] as? String ?? ""
        let roomArray = dictionary["arrRoom"] as? [String] ?? [""]
        let gender = dictionary["gender"] as? Gender ?? .unknown
        let numberPhone = dictionary["phoneNumber"] as? String ?? ""

        
        let senderType: SenderType = uid == currentUser?.uid ? .send : .receive
        
        let user = User(userName: userName, image: image, email: email, uid: uid, senderType: senderType, gender: gender, roomArray: roomArray, numberPhone: numberPhone)
        
        return user
    }
    
    static func registData(email: String, password: String, uid: String, userName: String) -> [String : Any] {
        let dataUser : [String : Any] = [
            "email" : email,
            "password" : password,
            "uid" : uid,
            "userName" : userName,
            "image" : "",
            "birthday" : "",
            "gender" : "",
            "phoneNumber": ""
        ]
        return dataUser
    }
}
