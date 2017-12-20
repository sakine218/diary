//
//  RecordViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var sumButton: UIButton!
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
    var sumTitle: String = ""
    var summeryArray: [Summery] = []
    var summery: Summery = Summery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "まとめる", style: .plain, target: self, action: #selector(sumRecord))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "RecordCell", bundle: nil), forCellWithReuseIdentifier: "RecordCell")
        collectionView.register(UINib(nibName: "SummeryRecordCell", bundle: nil), forCellWithReuseIdentifier: "SummeryRecordCell")
        //collectionView.center.x = self.view.center.x
        navigationItem.title = "記録"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Sumは\(summeryArray)")
        readData()
    }
    
    func readData() {
        let contents: [Content] = Content.findAll().filter({ $0.isSum == false })
        attendance.removeAll()
        for content in contents {
            attendance = attendance + content.attendanceArray.map({ $0 })
        }
        subjectArray.removeAll()
        if ((userDefaults.object(forKey: "Schedule")) != nil) {
            print("データ有り")
            scheduleArray = userDefaults.array(forKey: "Schedule") as! [[String : Any]]
        }
        for schedule in scheduleArray {
            subjectArray.append(schedule["subject"] as! String)
        }
        summeryArray = Summery.findAll()
        collectionView.reloadData()
    }
    
    //セクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return subjectArray.unique.count + 1 + summeryArray.count
    }
    
    //データ数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section <= subjectArray.unique.count  {
            return numOfDays
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section <=  subjectArray.unique.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCell
            if(indexPath.section == 0) {
                cell.textLabel.text = titleArray[indexPath.row]
            } else if(indexPath.row == 0 && indexPath.section == 0) {
                cell.textLabel.text = "教科"
            } else if(indexPath.row == 0 && indexPath.section != 0) {
                cell.textLabel.text = subjectArray.unique[indexPath.section - 1]
            } else if(indexPath.section != 0) {
                let subject: [Attendance] = attendance.filter({ $0.subjectText == subjectArray.unique[indexPath.section - 1]})
                //print(subject)
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummeryRecordCell", for: indexPath) as! SummeryRecordCell
            let summery: Summery = summeryArray[indexPath.section - subjectArray.unique.count - 1]
            cell.label.text = summery.title
            print(summery.title)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section <= subjectArray.unique.count {
            print("Num：\(indexPath.row) Section:\(indexPath.section)")
        } else {
            self.performSegue(withIdentifier: "toSummery", sender: summeryArray[indexPath.section - subjectArray.unique.count - 1])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 0.0
        var widths:CGFloat = 0.0
        var heights:CGFloat = 0.0
        if indexPath.section <= subjectArray.unique.count {
            widths = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(numOfDays)
            heights = widths * 0.5
        } else {
            widths = collectionView.frame.size.width
            heights = widths * 0.2
        }
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
    
    //まとめるボタンを押した時に呼ばれる
    func sumRecord() {
        let alert = UIAlertController(title: "まとめる", message: "タイトルを入力してください", preferredStyle: .alert)
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let text: String = (alert.textFields?.first?.text)!
            if  text != "" {
                self.matomeru(with: text)
                self.collectionView.reloadData()
            } else {
                let alert = UIAlertController(title: "", message: "タイトルが記入されていません", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
        alert.addAction(okAction)
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func matomeru(with title: String) {
        summery = Summery()
        summery.id = Summery.lastId()
        summery.title = title
        let realm: Realm = try! Realm()
        let contentArray: [Content] = realm.objects(Content.self).filter("isSum == false").map({ $0 })
        try! realm.write {
            for content in contentArray {
                summery.contents.append(content)
                content.isSum = true
            }
            realm.add(summery, update: true)
        }
        readData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! SummeryDetailViewController
        VC.summery = sender as! Summery
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

extension Array where Element: Equatable {
    var unique: [Element] {
        return reduce([]) { $0.0.contains($0.1) ? $0.0 : $0.0 + [$0.1] }
    }
}
