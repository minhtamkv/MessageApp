//
//  GroupTableViewCell.swift
//  Message
//
//  Created by Minh Tâm on 12/12/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import UIKit
import Firebase

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func getImageRoomFromUrl(with url: String){
        let url = URL(string: url)
        self.groupImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "Avatar"),
            options: [
                //.processor(processor),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
}
