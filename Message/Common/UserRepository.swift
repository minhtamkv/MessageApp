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
    
    func login (user : String , password : String , completion : @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: user, password: password) { [weak self] result, error -> Void in
            completion(result?.user.uid, error)
        }
    }
    
    func register (user : String , password : String , fullname: String , completion : @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: user, password: password) { [weak self] result, error -> Void in
            if error == nil {
                completion(result, nil)
                self?.registData(user: user, password: password, uid: result?.user.uid ?? "", fullname: "")
            } else {
                completion(nil, error)
                print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
            }
        }
    }
    
    func registData(user: String, password: String, uid: String, fullname: String) {
        let dataUser = User.registData(email: user, password: password, uid: uid, userName: fullname)
        self.database
            .collection(FirebaseConstants.users)
            .document(uid).setData(dataUser) { [weak self] error in
            if error == nil {
                print("Set data for \(uid) success")
            } else {
                print("Error : \(error?.localizedDescription)")
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
            database
                .collection(FirebaseConstants.users)
                .document(currentUser.uid)
                .getDocument { [weak self] querySnapshot, error -> Void in
                if let error = error {
                print("Error getting documents: \(error)")
                } else {
                    if let snapshot = querySnapshot, let dataCurrentUser = snapshot.data()  {
                            let user = User.map(uid: currentUser.uid, dictionary: dataCurrentUser)
                            completion(user, error)
                    }
                }
            }
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
        guard let currentUser = self.currentUser else { return }
        let reference = storageRef.child("\(filePath)/\(currentUser.uid).jpeg")
        reference.putData(dataImage, metadata: metaData) { [weak self] metaData, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                reference.downloadURL { [weak self] url, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        guard let currentUser = self?.currentUser else { return }
                        guard let url = url else { return }
                        self?.database.collection(FirebaseConstants.users)
                            .document(currentUser.uid)
                            .setData(["image" : "\(url.absoluteString)"], merge: true)
                    }
                }
            }
        }
    }
    
    public func fetchUser() {
        database.collection(FirebaseConstants.users).getDocuments(){ [weak self] querySnapshot, err in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   if let snapshot = querySnapshot {
                       for document in snapshot.documents {
                           let data = document.data()
                           let uid = data["uid"] as? String ?? ""
                        if uid != self?.currentUser?.uid {
                               let newUser = User.map(uid: uid, dictionary: data)
                            ChooseMembersViewController().users.append(newUser)
                           }
                       }
                   }
                ChooseMembersViewController().searchUser = ChooseMembersViewController().users
//                   self.tableView.reloadData()
               }
           }
       }
}
