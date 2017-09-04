//
//  RecordViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var sumButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    var attendance: [Attendance] = []
    let titleArray: [String] = ["教科","遅刻","早退","欠課"]
    let numOfDays = 4
    let cellMargin : CGFloat = 0.0
    let userDefaults = UserDefaults()
    var scheduleArray: [[String: Any]] = []
    var subjectArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "RecordCell", bundle: nil), forCellWithReuseIdentifier: "RecordCell")
        navigationItem.title = "記録"
        //scheduleArray.map()
        //subjectArray.append(scheduleArray["subject"] as! String)
        //print(subjectArray)
        //print(subjectArray.unique)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        attendance = Attendance.findAll()
        subjectArray.removeAll()
        if ((userDefaults.object(forKey: "Schedule")) != nil) {
            print("データ有り")
            scheduleArray = userDefaults.array(forKey: "Schedule") as! [[String : Any]]
        }
        for schedule in scheduleArray {
            subjectArray.append(schedule["subject"] as! String)
        }
        collectionView.reloadData()
        print(attendance)
    }
    
    //コレクションビューのセクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subjectArray.unique.count + 1
    }
    
    //データの個数（DataSourceを設定した場合に必要な項目）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDays
    }
    
    //データを返すメソッド（DataSourceを設定した場合に必要な項目）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //コレクションビューから識別子「CalendarCell」のセルを取得する
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
                let chikoku: [Attendance] = subject.filter({ $0.tapNum % 4 == 1})
                cell.textLabel.text = "\(chikoku.count)"
            } else if indexPath.row == 2 {
                let soutai: [Attendance] = subject.filter({ $0.tapNum % 4 == 2})
                cell.textLabel.text = "\(soutai.count)"
            } else if indexPath.row == 3 {
                let kekka: [Attendance] = subject.filter({ $0.tapNum % 4 == 3})
                cell.textLabel.text = "\(kekka.count)"
            }
        } else {
            cell.textLabel.text = "0"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num：\(indexPath.row) Section:\(indexPath.section)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 0.0
        let widths:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(numOfDays)
        let heights:CGFloat = widths * 0.5
        return CGSize(width:widths,height:heights)
    }
    
    //セルのアイテムのマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0)  //マージン(top , left , bottom , right)
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    //セルの垂直方向のマージンを設定
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

// reduceを用いて取り除いた場合
extension Array where Element: Equatable {
    var unique: [Element] {
        return reduce([]) { $0.0.contains($0.1) ? $0.0 : $0.0 + [$0.1] }
    }
}
