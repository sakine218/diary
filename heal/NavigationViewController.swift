//
//  NavigationViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBgImage = UIImage(named: "Image")
        self.navigationBar.setBackgroundImage(navBgImage, for: .default)
        // Do any additional setup after loading the view.
    }
    
    func sizeThatFits(size: CGSize) -> CGSize {
        let oldSize:CGSize = sizeThatFits(size: size)
        let newSize:CGSize = CGSize(width: oldSize.width, height: 84)
        return newSize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
