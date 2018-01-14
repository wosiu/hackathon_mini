//
//  Friend.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 14.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit

class Friend {
    
    let name: String
    let faceIamge: UIImage
    let event: String?
    
    init(name: String, faceImage: UIImage, event: String?) {
        self.name = name
        self.faceIamge = faceImage
        self.event = event
    }
    
}
