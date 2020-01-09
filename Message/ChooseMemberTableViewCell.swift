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
    
    var indexPath: IndexPath?
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(data: User) {
        userNameLabel?.text = "\(data.userName)"
        getImageUserFromUrl(with: data.image)
    }
    
    private func getImageUserFromUrl(with url: String) {
        let url = URL(string: url)
        self.userImageView.sd_setImage(with: url, completed: nil)
    }
}
