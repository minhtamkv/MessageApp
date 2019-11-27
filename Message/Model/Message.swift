//
//  Message.swift
//  Message
//
//  Created by Minh Tâm on 11/21/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var idMessage: String
    var content: String
    var uidRoom: String
    var image: String
    var timeSend: Double
    var uidUser: String
    var height: CGFloat
    var width: CGFloat
    
    init(idMessage: String, content: String, uidRoom: String, image: String,
         timeSend: Double, uidUser: String,  height: CGFloat, width: CGFloat) {
        self.content = content
        self.uidRoom = uidRoom
        self.image = image
        self.timeSend = timeSend
        self.uidUser = uidUser
        self.idMessage = idMessage
        self.height = height
        self.width = width
    }
}
