//
//  FireStoreManager.swift
//  Message
//
//  Created by Minh Tâm on 11/27/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import FirebaseAuth

class FireStoreManager {
    
    static let shared = FireStoreManager()
    
    private init() {}
    
    func login (user : String , password : String , completion : @escaping (String?, Error?) -> Void){
        Auth.auth().signIn(withEmail: user, password: password) { (result, error) -> Void in
            completion(result?.user.uid, error)
        }
    }
}
