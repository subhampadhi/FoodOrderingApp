//
//  TabBar.swift
//  FoodOrderingApp
//
//  Created by Subham Padhi on 02/11/18.
//  Copyright © 2018 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setUpTabs()
    }
    
    func setUpTabs(){
        let firstViewController = HomeVC()
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "plus"), tag: 0)
        
        let secondViewController = CartVC()
        secondViewController.tabBarItem = UITabBarItem(title: "Cart", image: #imageLiteral(resourceName: "minus"), tag: 1)
        
        let tabBarList = [firstViewController, secondViewController]
        viewControllers = tabBarList.map { UINavigationController(rootViewController: $0) }
    }
}
