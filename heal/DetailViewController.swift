//
//  DetailViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/23.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var content: Content?
    @IBOutlet var dateLabel: UILabel? = UILabel()
    @IBOutlet var noteLabel: UILabel? = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(content)
        dateLabel?.text = content?.date
        noteLabel?.text = content?.note
        // Do any additional setup after loading the view.
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
