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

private struct Constants {
    let numberOfSections: Int = 1
    let heightForRow: CGFloat = 80
}

class GroupViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet weak var groupTableView: UITableView!
    private var currentTime: NSNumber?
    private var searchRoom = [Room]()
    private let currentUser = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private var rooms = [Room]()
    
    let roomRepository = RoomRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        roomRepository.getRooms()
        groupTableView.reloadData()
    }
    
    func configListTableView() {
        groupTableView.register(cellType: GroupTableViewCell.self)
        groupTableView.delegate = self
        groupTableView.dataSource = self
    }
    
    @IBAction func profileTapped(_ sender: UIButton) {
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileViewController.modalPresentationStyle = .fullScreen
        self.present(profileViewController, animated: false, completion: nil)
    }
    
    @IBAction func contactTapped(_ sender: UIButton) {
    }
}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRoom.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants().numberOfSections
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants().heightForRow
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(for: indexPath) as GroupTableViewCell
        let room = searchRoom[indexPath.row]
        cell.setupCell(data: room)
            
        roomRepository.getInfoRoom(room: room)
        return cell
    }
}

extension GroupViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchRoom = rooms
            groupTableView.reloadData()
            return
        }
        searchRoom = rooms.filter {
            $0.nameGroup.lowercased().contains(searchText.lowercased())
        }
        groupTableView.reloadData()
    }
}
