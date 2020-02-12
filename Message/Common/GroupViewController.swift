//
//  GroupView.swift
//  Message
//
//  Created by Minh Tâm on 1/8/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Reusable
import Then

private enum Constants {
    static let numberOfSections = 1
    static let heightForRow: CGFloat = 80
}

class GroupViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var groupTableView: UITableView!
    private var currentTime: NSNumber?
    var searchRooms: [Room] = [] {
        didSet {
            groupTableView.reloadData()
        }
    }
    private let currentUser = Auth.auth().currentUser
    private let database = Firestore.firestore()
    var rooms = [Room]()
    private var messages = [Message]()
    
    private let roomRepository = RoomRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configListTableView()
        getRoom()
        searchRooms = self.rooms
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTableView.reloadData()
    }
    
    func configListTableView() {
        groupTableView.do {
            $0.register(cellType: GroupTableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    func setDataForArray(data: [Room]) {
        searchRooms = data
    }
    
    func getRoom() {
        roomRepository.getRooms() { [weak self] result, error in
            self?.searchRooms = result ?? []
        }
        self.rooms = searchRooms
    }
    
    @IBAction func contactTapped(_ sender: UIButton) {
    }
}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRooms.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRow
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(for: indexPath, cellType: GroupTableViewCell.self).then {
            let room = searchRooms[indexPath.row]
            $0.setupCell(data: room)
            self.messages = []
            roomRepository.getInfoOfRoom(room: room) { [weak self] result, error in
                self?.messages.append(result ?? Message(idMessage: "", content: "", uidRoom: "", image: "", timeSend: 0, uidUser: "", height: 0, width: 0))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = searchRooms[indexPath.row]
        let idRoom = room.idRoom
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let messageViewController = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
//        self.present(vc, animated: true, completion: nil)
        messageViewController.groupName = room.nameGroup
        messageViewController.idRoom = idRoom
        self.present(messageViewController, animated: false, completion: nil)
    }
}

extension GroupViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchRooms = rooms
            groupTableView.reloadData()
            return
        }
        searchRooms = rooms.filter {
            $0.nameGroup.lowercased().contains(searchText.lowercased())
        }
        groupTableView.reloadData()
    }
}
