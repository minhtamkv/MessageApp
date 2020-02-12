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
    func addUserToGroup(forUser userUid: String)
    func removeUserToGroup(forUser userUid: String)
    func didTapButtonInCell(_ cell: ChooseMemberTableViewCell)
}

class ChooseMemberTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet weak var selectUserButton: UIButton!
    
    weak var delegate: ChooseMemberTableViewCellDelegate?
    var isChoosen: Bool = false
    var userUid: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.image = UIImage(named: "Person")
        selectUserButton.isSelected = isChoosen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(data: User) {
        userNameLabel?.text = "\(data.userName)"
        let url = URL(string: data.image)
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        delegate?.didTapButtonInCell(self)
    }
}
