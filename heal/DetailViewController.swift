//
//  DetailViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/23.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var dateText: String = ""
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
        let content = setupContent()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "…", style: .plain, target: self, action: #selector(showAlert(_:)))
        navigationItem.rightBarButtonItem?.tintColor = AppColors.gray
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
    
    func setupContent() -> Content {
        if let content = self.content{
            return content
        } else {
            let content: Content = Content.find(withId: dateText) [0]
            return content
        }
    }
    
    func showAlert(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let edit = UIAlertAction(title: "編集", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("editをタップした時の処理")
            self.performSegue(withIdentifier: "toAdd", sender: nil)
        })
        let delete = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler: {
            (action: UIAlertAction!) in
            print("deleteをタップした時の処理")
            self.dispAlert()
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセルをタップした時の処理")
        })
        
        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func dispAlert() {
        let alert: UIAlertController = UIAlertController(title: "削除", message: "本当に削除しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            print("削除")
            let content = self.setupContent()
            content.delete()
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! AddDiaryViewController
        VC.dayText = (dateLabel?.text)!
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
