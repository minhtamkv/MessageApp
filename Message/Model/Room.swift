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
    
    static func map(idRoom: String, dictionary: [String: Any]) -> Room {
        let members = dictionary["uidMember"] as? [String] ?? [""]
        let image = dictionary["image"] as? String ?? ""
        let nameGroup = dictionary["nameRoom"] as? String ?? ""
        let time = dictionary["time"] as? NSNumber ?? 0
        let admins = dictionary["arrAdmin"] as? [String] ?? [""]
        
        let room = Room(nameGroup: nameGroup, idRoom: idRoom, image: image, time: time, uidMember: members, admins: admins)
        return room
    }
    
    static func addDataRoom(groupName: String, time: NSNumber, selectUserArray: [String]) -> [String : Any] {
        let dataRoom : [String : Any] = [
            "nameRoom" : groupName,
            "time" : time,
            "uidMember" : selectUserArray,
            "image" : "",
        ]
        return dataRoom
    }
}
