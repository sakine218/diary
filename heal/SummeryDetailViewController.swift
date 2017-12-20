//
//  SummeryDetailViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/10/05.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class SummeryDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var attendance: [Attendance] = []
    let titleArray: [String] = ["教科","遅刻","早退","欠課"]
    let numOfDays = 4
    let cellMargin: CGFloat = 0.0
    let userDefaults = UserDefaults()
    var scheduleArray: [[String: Any]] = []
    var subjectArray: [String] = []
    var chikoku: [Attendance]!
    var soutai: [Attendance]!
    var kekka: [Attendance]!
    var summery: Summery = Summery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "RecordCell", bundle: nil), forCellWithReuseIdentifier: "RecordCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = summery.title
        readData()
        print(summery)
    }
    
    func readData() {
        let contents: [Content] = summery.contents.map({ $0 })
        attendance.removeAll()
        for content in contents {
            attendance = attendance + content.attendanceArray.map({ $0 })
        }
        subjectArray.removeAll()
        subjectArray.removeAll()
        if ((userDefaults.object(forKey: "Schedule")) != nil) {
            print("データ有り")
            scheduleArray = userDefaults.array(forKey: "Schedule") as! [[String : Any]]
        }
        for schedule in scheduleArray {
            subjectArray.append(schedule["subject"] as! String)
        }
        collectionView.reloadData()
    }
    
    //セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subjectArray.unique.count + 1
    }
    
    //データ数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section <= subjectArray.unique.count  {
            return numOfDays
        } else {
            return 1
        }
    }
    
    //表示の設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCell
        if(indexPath.section == 0) {
            cell.textLabel.text = titleArray[indexPath.row]
        } else if(indexPath.row == 0 && indexPath.section == 0) {
            cell.textLabel.text = "教科"
        } else if(indexPath.row == 0 && indexPath.section != 0) {
            cell.textLabel.text = subjectArray.unique[indexPath.section - 1]
        } else if(indexPath.section != 0) {
            let subject: [Attendance] = attendance.filter({ $0.subjectText == subjectArray.unique[indexPath.section - 1]})
            print(subject)
            if indexPath.row == 1 {
                chikoku = subject.filter({ $0.tapNum % 4 == 1})
                cell.textLabel.text = "\(chikoku.count)"
            } else if indexPath.row == 2 {
                soutai = subject.filter({ $0.tapNum % 4 == 2})
                cell.textLabel.text = "\(soutai.count)"
            } else if indexPath.row == 3 {
                kekka = subject.filter({ $0.tapNum % 4 == 3})
                cell.textLabel.text = "\(kekka.count)"
            }
        } else {
            cell.textLabel.text = "0"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num：\(indexPath.row) Section:\(indexPath.section)")
        self.performSegue(withIdentifier: "toSummery", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 0.0
        var widths:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(numOfDays)
        var heights:CGFloat = widths * 0.5
        return CGSize(width:widths,height:heights)
    }
    
    //アイテムのマージン
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0)  //マージン(top , left , bottom , right)
    }
    
    //水平方向のマージン
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    //垂直方向のマージン
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
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

