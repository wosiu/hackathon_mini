//
//  ParticipaterVotesViewModel.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ParticipaterVotesViewModel {
    
    // MARK: - Properties
    
    public let event: Variable<Event?> = Variable(nil)
    
    // MARK: - Initialization
    
    init() {
        getEvent()
    }
    
    // MARK: - Actions
    
    func vote(postivie: Bool) {
        print("Voted: \(postivie)")
    }
    
    // MARK: - Helpers
    
    private func getEvent() {
        event.value = Event(name: "KEKEKAK", num: 20, iconName: "Book", des: "asdadsad")
    }
    
}
