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
        ApiService.defaultInstance.getEvents().then { [weak self](events) -> Void in
            self?.handleEvents(events: events)
        }
    }
    
    private func handleEvents(events: [Event]) {
        let headerOwning = "Owning"
        let headerParticipating = "Participating"
        var owning: [Event] = []
        var participating: [Event] = []
        for event in events {
            if event.ownerId == ApiService.defaultInstance.userId {
                owning.append(event)
            } else {
                participating.append(event)
            }
        }
        self.events.value = []
        if !owning.isEmpty {
            self.events.value.append((headerOwning, owning))
        }
        if !participating.isEmpty {
            self.events.value.append((headerParticipating, participating))
        }
    }
    
//    private func getEvents() {
//        let headerOwning = "Owning"
//        let headerParticipating = "Participating"
//        let owning: [Event] = []
//        let participating: [Event] = []
//
////        let owning = [Event(name: "HEHEHEHEHEHEH", num: 2, iconName: "Book", des: "sadfsadf"),
////                                   Event(name: "huashduhasu", num: 2, iconName: "Book", des: "sadfsadfasfd"),
////                                   Event(name: "hsadufh", num: 2, iconName: "Book", des: "")]
////
////        let participating = [Event(name: "HEHEHEHEHEHEH", num: 2, iconName: "Book", des: "sadfsadf"),
////                                        Event(name: "huashduhasu", num: 2, iconName: "Book", des: "sadfsadfasfd"),
////                                        Event(name: "hsadufh", num: 2, iconName: "Book", des: "")]
//        events.value = [(headerOwning, owning), (headerParticipating, participating)]
//    }
    
}
