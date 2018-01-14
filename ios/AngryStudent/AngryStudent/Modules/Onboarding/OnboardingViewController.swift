//
//  OnboardingViewController.swift
//  AngryStudent
//
//  Created by Paweł Czerwiński on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import UIKit


class OnboardingViewController: BasicViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    isLoading = true
    ApiService.defaultInstance.createUser().then {
      () -> Void in
      ApiService.defaultInstance.statrtSpammingLocation()
      
      ApiService.defaultInstance.createEvent(name: "asd", description: "asd", icon: "asd", roomId: "asd")
      self.present(TabBarViewController(nibName: nil, bundle: nil), animated: true)
      }.always {
        self.isLoading = false
    }
  }
}
