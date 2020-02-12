//
//  MessageRepository.swift
//  Message
//
//  Created by Minh Tâm on 2/12/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import Foundation
import Firebase

private enum FirebaseConstant {
    static let message = "message"
    static let msg = "msg"
    static let room = "room"
    static let users = "users"
    static let uid = "uid"
    static let time = "time"
}

class MessageRepository {
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    func getMessage(idRoom: String, completion: @escaping (([Message]?, Error?) -> Void)) {
            let getMessage = self.database.collection(FirebaseConstant.message)
            getMessage
                .document(idRoom)
                .collection(FirebaseConstant.msg)
                .addSnapshotListener{ [weak self] querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var messages = [Message]()
                    if let snapshot = querySnapshot {
                        for document in snapshot.documents {
                            let dataMessage = document.data()
                            
                            let uidRoom = dataMessage["toRoom"] as? String ?? ""
                            
                            if uidRoom == idRoom {
                                let idMessage = document.documentID
                                let newMessage = Message.map(idMessage: idMessage, dictionary: dataMessage)
                                messages.append(newMessage)
                            }
                        }
                        messages = messages.sorted(by: {
                            $0.timeSend.compare($1.timeSend) == .orderedAscending
                        })
                        completion(messages, err)
                    }
                }
            }
    }
}
