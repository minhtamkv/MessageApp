//
//  Room.swift
//  Message
//
//  Created by Minh Tâm on 11/21/19.
//  Copyright © 2019 Minh Tâm. All rights reserved.
//

import Foundation

struct Room {
    var nameGroup: String = ""
    var idRoom: String = ""
    var image: String = ""
    var time: NSNumber = 0
    var uidMember: [String] = [""]
    var admins: [String] = [""]
    
    init(image: String, nameGroup: String, time: NSNumber, admins: [String], members: [String], idRoom: String) {
        self.image = image
        self.nameGroup = nameGroup
        self.time = time
        self.admins = admins
        self.uidMember = members
        self.idRoom = idRoom
    }
    
    static func map(idRoom: String, dictionary: [String: Any]) -> Room {
        let members = dictionary["uidMember"] as? [String] ?? [""]
        let image = dictionary["image"] as? String ?? ""
        let nameGroup = dictionary["nameRoom"] as? String ?? ""
        let time = dictionary["time"] as? NSNumber ?? 0
        let admins = dictionary["arrAdmin"] as? [String] ?? [""]
        
        let room = Room(image: image, nameGroup: nameGroup, time: time, admins: admins, members: members, idRoom: idRoom)
        return room
    }
}
