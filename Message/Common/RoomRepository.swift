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
}

class RoomRepository {
    
    private var messages = [Message]()
    private var rooms = [Room]()
    private var searchRooms = [Room]()
    
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    func getInfoOfRoom(room: Room) {
        database.collection(FirebaseConstant.message)
            .document(room.idRoom)
            .collection(FirebaseConstant.msg)
            .addSnapshotListener { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self?.messages = []
                if let snapshot = querySnapshot {
                    guard let currentUser = self?.currentUser else { return }
                    for document in snapshot.documents {
                        let dataMessage = document.data()

                        let uidRoom = dataMessage["toRoom"] as? String ?? ""

                        if uidRoom == room.idRoom {
                            let idMessage = document.documentID
                            let newMessage = Message.map(idMessage: idMessage, dictionary: dataMessage)
                            self?.messages.append(newMessage)
                        }
                    }
                }
            }
        }
    }
    
    func getRooms() {
        DispatchQueue.global().async {
            let getRoom = self.database.collection(FirebaseConstant.room)
            getRoom.order(by: "time", descending: true).limit(to: 3)
            DispatchQueue.main.async {
                getRoom.addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let rooms = [Room]()
                        if let snapshot = querySnapshot {
                            for ducument in snapshot.documents {
                                let idRoom = ducument.documentID
                                let dataRooms = ducument.data()
                                let uidMember = dataRooms["uidMember"] as? [String] ?? [""]
                                guard let currentUser = self.currentUser else { return }
                                for value in uidMember {
                                    if value == currentUser.uid {
                                        let newRoom = Room.map(idRoom: idRoom, dictionary: dataRooms)
                                        self.rooms.append(newRoom)
                                    }
                                }
                            }
                        }
                        self.searchRooms = self.rooms
                    }
                }
            }
        }
    }
}
