//
//  UserRepository.swift
//  Message
//
//  Created by Minh Tâm on 11/27/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit


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

class UserRepository {
    
    let defaults = UserDefaults.standard
    
    func login (user: String, password: String, completion: @escaping ((String?, Error?) -> Void)?) {        FireStoreManager.shared.login(user: user, password: password) {_, error -> Void in
            if error != nil {
                completion?("Error", error)
            } else {
                self.saveLogin(username: user, password: password)
            }
        }
    }
    
    func saveLogin(username : String , password : String) {
        let person = Person(username: username, password: password)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: person)
        defaults.set(encodedData, forKey: "person")
        defaults.synchronize()
    }
}

