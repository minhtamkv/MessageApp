//
//  MembersViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/9/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import Reusable
import Then

private enum Constants {
    static let numberOfSection = 1
    static let heightForRows: CGFloat = 60
}

class ChooseMembersViewController: UIViewController {
    
    @IBOutlet private weak var searchMembers: UISearchBar!
    @IBOutlet private weak var listContacts: UITableView!
        
    private var searchUser = [User]()
    private let database = Firestore.firestore()
    private var userArray = [User]()
    private var currentUser = Auth.auth().currentUser
    private var roomRepository = RoomRepository()
    private var userRepository = UserRepository()
    
    var groupName: String?
    var selectUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configListTableView() {
        listContacts.do {
            $0.register(cellType: ChooseMemberTableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
        }
    }
        
    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: false)

    }
    
    @IBAction func handleDone(_ sender: UIButton) {
        guard let currentUser = currentUser, let groupName = groupName else { return }
        self.selectUserArray.append(currentUser.uid)
        let time: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        roomRepository.updateFirebase(groupName: groupName, time: time, selectUserArray: selectUserArray)
    }
    
}

extension ChooseMembersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchUser = userArray
        } else {
            searchUser = userArray.filter { $0.userName.lowercased().contains(searchText.lowercased())
            }
        }
        listContacts.reloadData()
    }
}

extension ChooseMembersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listContacts.dequeueReusableCell(for: indexPath, cellType: ChooseMemberTableViewCell.self).then {
            let user = searchUser[indexPath.row]
            $0.setupCell(data: user)
            $0.user = user
        }
        return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRows
    }
}

extension ChooseMembersViewController: ChooseMemberTableViewCellDelegate {
    func addUserToGroup(forUser user: User) {
        let selectedUserUid = user.uid
        selectUserArray.append(selectedUserUid)
    }
}
