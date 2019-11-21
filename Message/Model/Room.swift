//
//  Room.swift
//  Message
//
//  Created by Minh Tâm on 11/21/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation

class Room {
    var nameGroup: String
    var idRoom: String
    var image: String
    var time: NSNumber
    var uidMember: Array<String>?
    var arrAdmin: Array<String>

    init(idRoom: String, nameGroup : String, image: String, time: NSNumber, uidMember: Array<String>, arrAdmin: Array<String>) {
        self.nameGroup = nameGroup
        self.time = time
        self.image = image
        self.idRoom = idRoom
        self.uidMember = uidMember
        self.arrAdmin = arrAdmin
    }
}
