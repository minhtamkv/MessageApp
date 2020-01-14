//
//  CreateGroupViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/9/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase

final class CreateGroupViewController: UIViewController {

    @IBOutlet private weak var groupNameTextField: UITextField!
    
    private let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func handleCreateGroup(_ sender: UIButton) {
        guard let groupName = groupNameTextField.text else { return }
        if groupName.isEmpty {
            self.showAlert(message: "Tên nhóm chat không được để trống", title: "Thông báo")
        }
        let chooseMemberViewController = ChooseMembersViewController(nibName: "ChooseMembersViewController", bundle: nil)
        self.groupNameTextField.text = chooseMemberViewController.groupName
    }

}
