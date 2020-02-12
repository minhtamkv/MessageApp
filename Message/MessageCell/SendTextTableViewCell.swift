//
//  SendTextTableViewCell.swift
//  Message
//
//  Created by Minh Tâm on 1/10/20.
//  Copyright © 2020 Minh Tâm. All rights reserved.
//

import UIKit
import Reusable

final class SendTextTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var sendContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(data: Message) {
        sendContentLabel?.text = "\(data.content)"
    }
    
}
