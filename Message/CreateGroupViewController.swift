//
//  CreateGroupViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/9/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase

private enum Constants {
    static let nilString = ""
}

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    
    private let database = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: false)
    }
    
    @IBAction func handleCreateGroup(_ sender: UIButton) {
        guard let groupName = groupNameTextField.text else { return }
        if groupName == Constants.nilString {
            self.showAlert(message: "Tên nhóm chat không được để trống", title: "Thông báo")
        }
        let chooseMemberViewController = ChooseMembersViewController()
        self.groupNameTextField.text = chooseMemberViewController.groupName
    }

}
