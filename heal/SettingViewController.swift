//
//  SettingViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/07/12.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var howButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleButton.backgroundColor = UIColor.red
        howButton.backgroundColor = UIColor.red
        scheduleButton.cornerRadius = 20
        howButton.cornerRadius = 20
        // Do any additional setup after loading the view.
    }

    @IBAction func howButton(_ sender: Any) {
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
