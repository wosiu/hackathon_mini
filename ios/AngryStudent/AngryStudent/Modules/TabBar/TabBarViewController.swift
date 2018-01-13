//
//  TabBarViewController.swift
//  AngryStudent
//
//  Created by Mateusz Orzoł on 13.01.2018.
//  Copyright © 2018 Paweł Czerwiński. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    let viewModel = TabBarViewModel()
    var tabBarViewControllers: [UIViewController] = []
    
    // MARK: - Outlets
    
    // MARK: - Actions
    
    // MARK: - Initialization
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Helpers
    
    private func setupTabBar() {
        tabBar.barTintColor = Color.white
        tabBar.shadowImage = nil
        tabBar.backgroundColor = Color.white
        tabBar.tintColor = Color.blueDark
        //tabBar.backgroundImage = UIImage()
        //tabBar.layer.backgroundColor = Color.clear.cgColor
        setupTabBarControllers()
    }
    
    private func setupTabBarControllers() {
        let tabBarItems = viewModel.getTabBarItems()
        initializeViewControllers()
        for (index, tabBarViewController) in tabBarViewControllers.enumerated() {
            tabBarViewController.tabBarItem = tabBarItems[index]
        }
        self.viewControllers = tabBarViewControllers
    }
    
    private func initializeViewControllers() {
        let eventVC = UIStoryboard(name: "EventsMap", bundle: nil).instantiateInitialViewController()
        let mapVC = UIStoryboard(name: "HomeMap", bundle: nil).instantiateInitialViewController()
        let friendsVc = UIStoryboard(name: "Friends", bundle: nil).instantiateInitialViewController()
        tabBarViewControllers = [eventVC!, mapVC!, friendsVc!]
    }
}
