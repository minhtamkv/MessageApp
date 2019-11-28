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

class UserRepository {
    
    static let shared = UserRepository()
    let defaults = UserDefaults.standard
    
    func login(user : String , password : String , completion : @escaping (String?, Error?) -> Void) {
        FireStoreManager.shared.login(user: user, password: password) {_, error -> Void in
            if error != nil {
                ViewController.shared.showAlert(message: "Đã có lỗi xảy ra", title: "Thử lại")
            } else {
                self.saveLogin(username: user, password: password)
            }
        }
    }
    
    func saveLogin(username : String , password : String) {
        self.defaults.set(username, forKey: "username")
        self.defaults.set(password, forKey: "password")
        self.defaults.set(true, forKey: "islogin")
    }
}

