//
//  UserRepository.swift
//  Message
//
//  Created by Minh Tâm on 11/27/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import UIKit

class UserRepository {
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    func login (user: String, password: String, completion: @escaping ((String?, Error?) -> Void)?) {
        FireStoreManager.shared.login(user: user, password: password) {_, error -> Void in
            if error != nil {
                completion?("Error", error)
            } else {
                self.saveLogin(username: user, password: password)
            }
        }
    }
    
    func register (user: String, password: String, fullname: String, completion: @escaping ((String?, Error?) -> Void)?) {        FireStoreManager.shared.register(user: user, password: password) { error, result -> Void in
            if error != nil {
                guard let `uid` = result?.user.uid else {
                    print("Not user registed")
                    return
                }
            } else {
                self.registData(user: user, password: password, uid: result?.user.uid ?? "", fullname: fullname)
            }
        }
    }
    
    func registData(user: String, password: String, uid: String, fullname: String) {
        let data : [String : Any] = [
            "email" : user,
            "password" : password,
            "uid" : uid,
            "userName" : fullname,
            "image" : "",
            "birthday" : "",
            "gender" : ""
        ]
        self.db.collection("users").document(uid).setData(data){ err in
            if err == nil {
                print("Set data for \(uid) success")
            } else {
                print("Error : \(err?.localizedDescription)")
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

