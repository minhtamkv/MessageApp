//
//  ChooseMemberTableViewCell.swift
//  Message
//
//  Created by Minh Tâm on 1/9/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

protocol ChooseMemberTableViewCellDelegate: AnyObject {
    func addUserToGroup(forUser user: User)
}

class ChooseMemberTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var chooseButton: UIButton!
    
    func setupCell(data: User) {
        userNameLabel?.text = "\(data.userName)"
        let url = URL(string: data.image)
        userImageView.sd_setImage(with: url, completed: nil)        
    }
}
