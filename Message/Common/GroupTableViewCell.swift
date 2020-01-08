//
//  GroupTableViewCell.swift
//  Message
//
//  Created by Minh Tâm on 12/12/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase
import Reusable
import SDWebImageSwiftUI
import SDWebImage

final class GroupTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(data: Room) {
        self.groupName?.text = "\(data.nameGroup)"
        self.getImageRoomFromUrl(with: data.image)
    }
    
    func getImageRoomFromUrl(with url: String) {
        let url = URL(string: url)
        self.groupImage.sd_setImage(with: url, completed: nil)
    }
    
}
