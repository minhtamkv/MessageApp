//
//  Message.swift
//  Message
//
//  Created by Minh Tâm on 11/21/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import UIKit

struct Message {
    var idMessage: String = ""
    var content: String = ""
    var uidRoom: String = ""
    var image: String = ""
    var timeSend: Double = 0.0
    var uidUser: String = ""
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    
    init(idMessage: String, content: String, uidRoom: String, image: String, timeSend: Double, uidUser: String, height: CGFloat, width: CGFloat) {
        self.idMessage = idMessage
        self.content = content
        self.uidRoom = uidRoom
        self.image = image
        self.timeSend = timeSend
        self.uidUser = uidUser
        self.height = height
        self.width = width
    }
    
    static func map(idMessage: String, dictionary: [String: Any]) -> Message {
        let content = dictionary["content"] as? String ?? ""
        let uidRoom = dictionary["toRoom"] as? String ?? ""
        let image = dictionary["image"] as? String ?? ""
        let idUser = dictionary["fromUser"] as? String ?? ""
        let time = dictionary["time"] as? Double ?? 0
        let height = dictionary["height"] as? CGFloat ?? 0
        let width = dictionary["width"] as? CGFloat ?? 0
        
        let message = Message(idMessage: idMessage, content: content, uidRoom: uidRoom, image: image, timeSend: time, uidUser: idUser, height: height, width: width)
        return message
    }
}
