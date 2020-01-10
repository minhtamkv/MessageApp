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
    
    static func map(uid: String, dictionary: [String: Any]) -> User {
        let currentUser = Auth.auth().currentUser
        let userName = dictionary["userName"] as? String ?? ""
        let email = dictionary["email"] as? String ?? ""
        let image = dictionary["image"] as? String ?? ""
        let roomArray = dictionary["rooms"] as? [String] ?? [""]
        let gender = dictionary["gender"] as? Gender ?? .unknown
        let numberPhone = dictionary["phoneNumber"] as? String ?? ""
        
        let senderType: SenderType = uid == currentUser?.uid ? .send : .receive
        
        let user = User(uid: uid, email: email, userName: userName, gender: gender, senderType: senderType, image: image, roomArray: roomArray, numberPhone: numberPhone)
        
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
