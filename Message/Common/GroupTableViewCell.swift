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
import SDWebImage

final class GroupTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var groupImageView: UIImageView!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(data: Room) {
        groupNameLabel?.text = "\(data.nameGroup)"
        getImageRoomFromUrl(with: data.image)
    }
    
    private func getImageRoomFromUrl(with url: String) {
        let url = URL(string: url)
        self.groupImageView.sd_setImage(with: url, completed: nil)
    }
}
