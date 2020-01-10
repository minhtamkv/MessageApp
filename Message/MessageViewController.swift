//
//  MessageViewController.swift
//  Message
//
//  Created by Minh Tâm on 1/10/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import Then
import Reusable

private enum Constants {
    static let numberOfSections = 1
}

final class MessageViewController: UIViewController {
        
    @IBOutlet private weak var nameGroupLabel: UILabel!
    @IBOutlet private weak var mesasgeTableView: UITableView!
    @IBOutlet private weak var inputTextField: UITextView!
    
    var idRoom: String?
    var groupName: String = ""
    private var messages = [Message]()
    private let currentUser = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    
    func configTableView() {
        mesasgeTableView.do {
            $0.register(cellType: SendTextTableViewCell.self)
            $0.register(cellType: ReceiveTextTableViewCell.self)
            $0.register(cellType: SendImageTableViewCell.self)
            $0.register(cellType: ReceiveImageTableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
        }
    }

    @IBAction func handleSendButton(_ sender: UIButton) {
    
    }
    
    @IBAction func handleAttackButton(_ sender: UIButton) {
    
    }
    
    @IBAction func handleBackButton(_ sender: UIButton) {
    
    }
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        let cell = mesasgeTableView.dequeueReusableCell(for: indexPath, cellType: SendTextTableViewCell.self)
        return cell
    }
    
}
