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
    func removeUserToGroup(forUser user: User)
}

class ChooseMemberTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var selectUserButton: UIButton!
    
    weak var delegate: ChooseMemberTableViewCellDelegate?
    var indexPath: IndexPath?
    var user: User?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let user = user else { return }
        selectUserButton.isSelected = user.isSelected
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.image = UIImage(named: "Person")
        guard let user = user else { return }
        selectUserButton.isSelected = user.isSelected

//        configCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell() {
        self.userImageView.image = UIImage(named: "Person")
        guard let user = user else { return }
        selectUserButton.isSelected = user.isSelected
    }
    
    func setupCell(data: User) {
        userNameLabel?.text = "\(data.userName)"
        let url = URL(string: data.image)
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        guard var user = user else { return }
        sender.isSelected = !sender.isSelected
        user.isSelected = sender.isSelected
        if user.isSelected {
            delegate?.addUserToGroup(forUser: user)
        } else {
            delegate?.removeUserToGroup(forUser: user)
        }
    }
}
