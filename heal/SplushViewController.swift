//
//  SplushViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/26.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class SplushViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var timer:Timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                       target: self,
                                                       selector: #selector(changeView),
                                                       userInfo: nil,
                                                       repeats: false)
        // Do any additional setup after loading the view.
    }
    
    func changeView() {
        self.performSegue(withIdentifier: "nextVC", sender: nil)
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
