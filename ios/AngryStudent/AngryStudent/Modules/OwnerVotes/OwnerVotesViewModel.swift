//
//  OwnerVotesViewModel.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class OwnerVotesViewModel {
    
    // MARK: - Properties
    
    public let groupEvent: Variable<GroupEvent?> = Variable(nil)
    
    // MARK: - Initialization
    
    init() {
        getGroupEvent()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func getGroupEvent() {
        groupEvent.value = GroupEvent(name: "KEKekerino", num: 20, iconName: "Book", des: "asdflknasnfsnfnkl")
    }
    
}
