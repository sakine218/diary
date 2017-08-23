//
//  ParentTabBarController.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/20.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class ParentTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let selectesIconNames = ["calendar0", "note0", "plus0", "record0", "set0"]
    let unseletedIconNames = ["calendar1", "note1", "plus1", "record1", "set1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        if let count = self.tabBar.items?.count {
            for i in 0...count-1 {
                let imageNameForSelectedState   = selectesIconNames[i]
                let imageNameForUnselectedState = unseletedIconNames[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState)?.withRenderingMode(.alwaysOriginal)
            }
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.gray], for: .selected)
        tabBar.barTintColor = UIColor.white
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
