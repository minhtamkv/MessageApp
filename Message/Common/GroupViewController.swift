//
//  GroupViewController.swift
//  Message
//
//  Created by Minh Tâm on 12/12/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchGroup: UISearchBar!
    @IBOutlet weak var groupTableView: UITableView!
    var searchRoom = [Room]()
    var isChoosen: Bool?
    var roomArray = [Room]()
    var arrMessage = [Message]()
    var currentTime: NSNumber?
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    var arrUnreadMessage = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configListTableView()

    }
    
    func configListTableView() {
        let cell = UINib(nibName: "GroupTableViewCell", bundle: nil)
        self.groupTableView.register(cell, forCellReuseIdentifier: "GroupTableViewCell")
        groupTableView.delegate = self
        groupTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRoom.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell") as! GroupTableViewCell
        let room = searchRoom[indexPath.row]
        cell.groupName?.text = "\(room.nameGroup)"
        cell.getImageRoomFromUrl(with: room.image)
        
        db.collection("message").document(room.idRoom).collection("msg").addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.arrMessage = []
                self.arrUnreadMessage = []
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
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchRoom = roomArray
            groupTableView.reloadData()
            return
        }
        searchRoom = roomArray.filter({ room -> Bool in
            (room.nameGroup.lowercased().contains(searchText.lowercased()) )
        })
        groupTableView.reloadData()
    }
    
    func getRooms(){
        db.collection("room").addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.roomArray = []
                if let snapshot = querySnapshot {
                    for ducument in snapshot.documents {
                        let idRoom = ducument.documentID
                        let dataRooms = ducument.data()
                        let uidMember = dataRooms["uidMember"] as? Array<String> ?? [""]
                        guard let `currentUser` = self.currentUser else {return}
                        for value in uidMember {
                            if value == currentUser.uid {
                                let dataRooms = ducument.data()
                                let image = dataRooms["image"] as? String ?? ""
                                let nameRoom = dataRooms["nameRoom"] as? String ?? ""
                                let timeRoom = dataRooms["time"] as? NSNumber ?? 0
                                let arrAdmin = dataRooms["arrAdmin"] as? Array<String> ?? [""]
                                let newRoom = Room(nameGroup: nameRoom, idRoom: idRoom, image: image, time: timeRoom, uidMember: uidMember, arrAdmin: arrAdmin)
                                self.roomArray.append(newRoom)
                            }
                        }
                    }
                    self.roomArray = self.roomArray.sorted(by: {
                        $0.time.compare($1.time) == .orderedDescending
                    })
                }
                self.searchRoom = self.roomArray
                self.groupTableView.reloadData()
            }
        }
    }
    
    @IBAction func profileTapped(_ sender: UIButton) {
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileViewController.modalPresentationStyle = .fullScreen
        self.present(profileViewController, animated: false, completion: nil)
    }
    
    @IBAction func contactTapped(_ sender: UIButton) {
    }
    
}
