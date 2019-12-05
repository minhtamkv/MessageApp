//
//  Person.swift
//  Message
//
//  Created by Minh Tâm on 12/4/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {
    let username: String
    let password: String
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    required init(coder decoder: NSCoder) {
        self.username = decoder.decodeObject(forKey: "username") as? String ?? ""
        self.password = decoder.decodeObject(forKey: "password") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(password, forKey: "password")
    }
}
