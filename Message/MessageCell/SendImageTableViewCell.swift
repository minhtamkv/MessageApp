//
//  SendImageTableViewCell.swift
//  Message
//
//  Created by Minh Tâm on 1/10/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Reusable

final class SendImageTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var sendImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(data: Message) {
        self.sendImageView.frame.size = CGSize(width: data.height, height: data.width)
        let url = URL(string: data.image)
        sendImageView.sd_setImage(with: url, completed: nil)
    }
    
}
