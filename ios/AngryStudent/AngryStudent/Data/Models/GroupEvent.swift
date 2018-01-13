//
//  GroupEvent.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupEvent: Mappable {
    
    public private(set) var groupId: Int?
    public private(set) var name: String?
    public private(set) var description: String?
    public private(set) var viewersNum: Int?
    public private(set) var ownerId: String?
    public private(set) var idnoorRoomId: String?
    public private(set) var iconName: String?
    public private(set) var votes: Votes?
    
    public init(name: String, num: Int, iconName: String, des: String?) {
        self.name = name
        self.viewersNum = num
        self.iconName = iconName
        self.description = des
        self.votes = Votes(idle: 10, ok: 3, bad: [1,1,1,1,1])
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        groupId            <- map["group-id"]
        name               <- map["group-name"]
        description        <- map["description"]
        viewersNum         <- map["current-viewers-num"]
        ownerId            <- map["owner-id"]
        idnoorRoomId       <- map["indoor-room-id"]
        iconName           <- map["data"]
        votes              <- map["data"]
    }
}

class Votes: Mappable {
    
    public private(set) var idle: Int?
    public private(set) var ok: Int?
    public private(set) var bad: [Int] = []
    
    public init(idle: Int, ok: Int, bad: [Int]) {
        self.idle = idle
        self.ok = ok
        self.bad = bad
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        idle             <- map["idle"]
        ok               <- map["ok"]
        bad              <- map["bad"]
    }
    
}
