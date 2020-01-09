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
import FirebaseFirestore
import UIKit

private enum FirebaseConstants {
    static let users = "users"
}

class UserRepository {
    
    private let defaults = UserDefaults.standard
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    func login (user: String, password: String, completion: @escaping ((String?, Error?) -> Void)) {
        FireStoreManager.shared.login(user: user, password: password) { result ,error -> Void in
            if error != nil {
                completion("Error", error)
            } else {
                completion(result, error)
                self.saveLogin(username: user, password: password)
            }
        }
    }
    
    func register (user: String, password: String, fullname: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {        FireStoreManager.shared.register(user: user, password: password) { result, error -> Void in
            if error != nil {
                guard let uid = result?.user.uid else {
                    print("Not user registed")
                    return
                }
            } else {
                completion(result, error)
                self.registData(user: user, password: password, uid: result?.user.uid ?? "", fullname: fullname)
            }
        }
    }
    
    func registData(user: String, password: String, uid: String, fullname: String) {
        let dataUser = User.registData(email: user, password: password, uid: uid, userName: fullname)
        self.database.collection(FirebaseConstants.users).document(uid).setData(dataUser) { err in
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
    
    func fetchCurrentUser(completion: @escaping ((User?, Error?) -> Void)) {
        if let currentUser = self.currentUser {
            database.collection("users").document(currentUser.uid).getDocument(completion: { querySnapshot, err -> Void in
                if let err = err {
                print("Error getting documents: \(err)")
                } else {
                    if let snapshot = querySnapshot {
                        if let dataCurrentUser = snapshot.data() {
                            let user = User.map(uid: currentUser.uid, dictionary: dataCurrentUser)
                            completion(user, err)
                        }
                    }
                }
            })
        }
    }
    
    func uploadAvatarToFirebase(image :UIImage?) {
        var dataImage = Data()
        if let data = image?.pngData() {
            dataImage = data
        }
        else if let data = image?.jpegData(compressionQuality: 1) {
            dataImage = data
        }
        
        let filePath = "images"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let storageRef = Storage.storage().reference()
        guard let `currentUser` = self.currentUser else { return }
        let reference = storageRef.child("\(filePath)/\(currentUser.uid).jpeg")
        reference.putData(dataImage, metadata: metaData) { metaData, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                reference.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        guard let `currentUser` = self.currentUser else { return }
                        guard let `url` = url else { return }
                        self.database.collection(FirebaseConstants.users)
                            .document(currentUser.uid)
                            .setData(["image" : "\(url.absoluteString)"], merge: true)
                    }
                })
            }
        }
    }
    
}
