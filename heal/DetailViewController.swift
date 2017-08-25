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
    var redValue: CGFloat = CGFloat()
    var greenValue: CGFloat = CGFloat()
    var blueValue: CGFloat = CGFloat()
    @IBOutlet var dateLabel: UILabel? = UILabel()
    @IBOutlet var noteLabel: UILabel? = UILabel()
    @IBOutlet var scheduleLabelArray: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let content = content else { return }
        print(content)
        redValue = CGFloat(content.redValue)
        greenValue = CGFloat(content.greenValue)
        blueValue = CGFloat(content.blueValue)
        dateLabel?.text = content.date
        dateLabel?.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha: 1.0)
        noteLabel?.text = content.note
        for (index, attendence) in content.attendanceArray.enumerated() {
            scheduleLabelArray[index].text = content.attendanceArray[index].subjectText
            if content.attendanceArray[index].tapNum % 4 == 1 {
                scheduleLabelArray[index].backgroundColor = AppColors.pink
                scheduleLabelArray[index].textColor = UIColor.white
            } else if content.attendanceArray[index].tapNum % 4 == 2 {
                scheduleLabelArray[index].backgroundColor = AppColors.sky
                scheduleLabelArray[index].textColor = UIColor.white
            } else if content.attendanceArray[index].tapNum % 4 == 3 {
                scheduleLabelArray[index].backgroundColor = AppColors.yellow
                scheduleLabelArray[index].textColor = UIColor.white
            } else {
                scheduleLabelArray[index].textColor = AppColors.gray
            }
        }
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
