//
//  Event.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import ObjectMapper

class Event: Mappable {
    
    public private(set) var id: Int?
    public private(set) var name: String?
    public private(set) var description: String?
    public private(set) var viewersNum: Int?
    public private(set) var ownerId: String?
    public private(set) var idnoorRoomId: String?
    public private(set) var iconName: String?
    
    public init(name: String, num: Int, iconName: String, des: String?) {
        self.name = name
        self.viewersNum = num
        self.iconName = iconName
        self.description = des
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        id                 <- map["group-id"]
        name               <- map["group-name"]
        description        <- map["description"]
        viewersNum         <- map["current-viewers-num"]
        ownerId            <- map["owner-id"]
        idnoorRoomId       <- map["indoor-room-id"]
        iconName           <- map["data"]
    }
}
