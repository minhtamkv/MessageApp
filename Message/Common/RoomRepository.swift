//
//  RoomRepository.swift
//  Message
//
//  Created by Minh Tâm on 1/8/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

private enum FirebaseConstant {
    static let message = "message"
    static let msg = "msg"
    static let room = "room"
    static let users = "users"
    static let uid = "uid"
}

class RoomRepository {
        
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    func getInfoOfRoom(room: Room, completion: @escaping ((Message?, Error?) -> Void)) {
        database.collection(FirebaseConstant.message)
            .document(room.idRoom)
            .collection(FirebaseConstant.msg)
            .addSnapshotListener { [weak self] querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshot = querySnapshot {
                    guard let currentUser = self?.currentUser else { return }
                    for document in snapshot.documents {
                        let dataMessage = document.data()

                        let uidRoom = dataMessage["toRoom"] as? String ?? ""

                        if uidRoom == room.idRoom {
                            let idMessage = document.documentID
                            let newMessage = Message.map(idMessage: idMessage, dictionary: dataMessage)
                            completion(newMessage, err)
                        }
                    }
                }
            }
        }
    }
    
    func getRooms(completion: @escaping ((Room?, Error?) -> Void)) {
        DispatchQueue.global().async {
            let getRoom = self.database.collection(FirebaseConstant.room)
            getRoom.order(by: "time", descending: true)
            DispatchQueue.main.async {
                getRoom.addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        if let snapshot = querySnapshot {
                            for ducument in snapshot.documents {
                                let idRoom = ducument.documentID
                                let dataRooms = ducument.data()
                                let uidMember = dataRooms["uidMember"] as? [String] ?? [""]
                                guard let currentUser = self.currentUser else { return }
                                for value in uidMember {
                                    if value == currentUser.uid {
                                        let newRoom = Room.map(idRoom: idRoom, dictionary: dataRooms)
                                        completion(newRoom, err)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateFirebase(groupName: String, time: NSNumber, selectUserArray: [String]) {
        guard let currentUser = currentUser else { return }
        
        // Update Room data to Firebase: Update new information of this new Room
        
        let time: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let dataRoom = Room.addDataRoom(groupName: groupName, time: time, selectUserArray: selectUserArray)
        
        let referenceRoom = self.database
            .collection(FirebaseConstant.room)
            .addDocument(data: dataRoom) { err in
            if err == nil {
                print("Set data success")
            } else {
                print("Error : \(err?.localizedDescription)")
            }
        }
        
        // Update User data to Firebase: Update id Room of User to current User
        
        let uidRoom = referenceRoom.documentID

        let reference = database
           .collection(FirebaseConstant.users)
           .document(currentUser.uid)
        reference
            .updateData([
            "arrRoom": FieldValue.arrayUnion([uidRoom]),
            ])
        database
           .collection(FirebaseConstant.users)
           .getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                       let uidUser = data[FirebaseConstant.uid] as? String ?? ""
                        for value in selectUserArray {
                            if value == uidUser {
                                self.database
                                    .collection(FirebaseConstant.users)
                                    .document(uidUser)
                                    .updateData([
                                    "arrRoom": FieldValue.arrayUnion([uidRoom])
                                    ])
                            }
                        }
                    }
                }
            }
        }
    }
}
