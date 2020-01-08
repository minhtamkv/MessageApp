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

class RoomRepository {
    let db = Firestore.firestore()
    var arrMessage = [Message]()
    let currentUser = Auth.auth().currentUser
    var rooms = [Room]()
    var searchRoom = [Room]()
    
    func getInfoRoom(room: Room) {
        db.collection("message").document(room.idRoom).collection("msg").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.arrMessage = []
                if let snapshot = querySnapshot {
                    guard let `currentUser` = self.currentUser else { return }
                    for document in snapshot.documents {
                        let dataMessage = document.data()

                        let uidRoom = dataMessage["toRoom"] as? String ?? ""
                        let time = dataMessage["time"] as? NSNumber ?? 0
                        let uidUser = dataMessage["fromUser"] as? String ?? ""

                        if uidRoom == room.idRoom {
                            let idMessage = document.documentID
                            let content = dataMessage["content"] as? String ?? ""
                            let image = dataMessage["image"] as? String ?? ""
                            let height = dataMessage["height"] as? CGFloat ?? 0
                            let width = dataMessage["width"] as? CGFloat ?? 0
                            let newMessage = Message(idMessage: idMessage, content: content, uidRoom: uidRoom, image: image, timeSend: Double(time), uidUser: uidUser, height: height, width: width)
                            self.arrMessage.append(newMessage)
                        }
                    }
                }
            }
        }
    }
    
    func getRooms() {
        db.collection("room").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let rooms = [Room]()
                if let snapshot = querySnapshot {
                    for ducument in snapshot.documents {
                        let idRoom = ducument.documentID
                        let dataRooms = ducument.data()
                        let uidMember = dataRooms["uidMember"] as? [String] ?? [""]
                        guard let `currentUser` = self.currentUser else {return}
                        for value in uidMember {
                            if value == currentUser.uid {
                                let dataRooms = ducument.data()
                                let image = dataRooms["image"] as? String ?? ""
                                let nameRoom = dataRooms["nameRoom"] as? String ?? ""
                                let timeRoom = dataRooms["time"] as? NSNumber ?? 0
                                let arrAdmin = dataRooms["arrAdmin"] as? [String] ?? [""]
                                let newRoom = Room(nameGroup: nameRoom, idRoom: idRoom, image: image, time: timeRoom, uidMember: uidMember, arrAdmin: arrAdmin)
                                self.rooms.append(newRoom)
                            }
                        }
                    }
                    self.rooms = self.rooms.sorted {
                        $0.time.compare($1.time) == .orderedDescending
                    }
                }
                self.searchRoom = self.rooms
            }
        }
    }
}
