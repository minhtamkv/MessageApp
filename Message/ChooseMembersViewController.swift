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

final class ChooseMembersViewController: UIViewController {
    
    @IBOutlet private weak var searchMembers: UISearchBar!
    @IBOutlet private weak var listContacts: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var searchUser = [User]() {
        didSet {
            listContacts.reloadData()
        }
    }
    private let database = Firestore.firestore()
    var users = [User]()
    private var currentUser = Auth.auth().currentUser
    private var roomRepository = RoomRepository()
    private var userRepository = UserRepository()
    
    var groupName: String?
    private var selectUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configListTableView()
        configSearchBar()
        fetchUser()
        
    }
    
    func configListTableView() {
        listContacts.do {
            $0.register(cellType: ChooseMemberTableViewCell.self)
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
    func configSearchBar() {
        searchBar.delegate = self
    }
    
    func fetchUser() {
        userRepository.fetchUser() { [weak self] result, error in
            self?.searchUser = result ?? []
        }
    }
        
    @IBAction func handleBack(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func handleDone(_ sender: UIButton) {
        guard let currentUser = currentUser, let groupName = groupName else { return }
        self.selectUserArray.append(currentUser.uid)
        let time = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        roomRepository.updateFirebase(groupName: groupName, time: time, selectUserArray: selectUserArray)
    }
    
}

extension ChooseMembersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchUser = users
        } else {
            searchUser = users.filter { $0.userName.lowercased().contains(searchText.lowercased()) }
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
            $0.delegate = self
            $0.userUid = user.uid
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRows
    }
}

extension ChooseMembersViewController: ChooseMemberTableViewCellDelegate {
    func addUserToGroup(forUser userUid: String) {
        selectUserArray.append(userUid)
    }
    func removeUserToGroup(forUser userUid: String) {
        let removeUser = selectUserArray.filter { $0 == userUid }.first
        if let removeUserIndex = selectUserArray.firstIndex(where: { $0 == removeUser}) {
            selectUserArray.remove(at: removeUserIndex)
        }
    }
    func didTapButtonInCell(_ cell: ChooseMemberTableViewCell) {
        guard let userUid = cell.userUid else { return }
        cell.selectUserButton.isSelected = !cell.selectUserButton.isSelected
        cell.isChoosen = cell.selectUserButton.isSelected
        if cell.isChoosen {
            addUserToGroup(forUser: userUid)
        } else {
            removeUserToGroup(forUser: userUid)
        }
    }

}
