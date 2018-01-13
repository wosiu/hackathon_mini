//
//  EventViewModel.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EventViewModel {
    
    // MARK: - Properties
    
    public let events: Variable<[(header: String, [Event])]> = Variable([])
    
    // MARK: - Initialization
    
    init() {
        getEvents()
    }
    
    // MARK: - Actions
    
    func openOwnerEventInfo() {
        
    }

    func openParticipateEventInfo() {
        
    }
    
    // MARK: - Helpers
    
    private func getEvents() {
        let headerOwning = "Owning"
        let headerParticipating = "Participating"

        let owning = [Event(name: "HEHEHEHEHEHEH", num: 2, iconName: "Book", des: "sadfsadf"),
                                   Event(name: "huashduhasu", num: 2, iconName: "Book", des: "sadfsadfasfd"),
                                   Event(name: "hsadufh", num: 2, iconName: "Book", des: "")]
        
        let participating = [Event(name: "HEHEHEHEHEHEH", num: 2, iconName: "Book", des: "sadfsadf"),
                                        Event(name: "huashduhasu", num: 2, iconName: "Book", des: "sadfsadfasfd"),
                                        Event(name: "hsadufh", num: 2, iconName: "Book", des: "")]
        events.value = [(headerOwning, owning), (headerParticipating, participating)]
    }
    
}
