//
//  ScheduleViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/07/12.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    var number: Int = 0
    let weekArray = ["","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let numOfDays = 7
    let cellMargin : CGFloat = 0.0
    let userDefaults = UserDefaults.standard
    var scheduleArray: [[String: Any]] = []
    var subjectArray: [String] = []
    let barButtonItemBg = UIImage(named: "barButtonItemBg.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  "時間割"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "…", style: .plain, target: self, action: #selector(selectBarItem))
        navigationItem.rightBarButtonItem?.tintColor = AppColors.gray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ScheduleViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (userDefaults.array(forKey: "Schedule") != nil) {
            scheduleArray = userDefaults.array(forKey: "Schedule") as! [[String : Any]]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectBarItem() {
        number = number + 1
        if number % 2 == 0 {
            navigationItem.rightBarButtonItem?.title = "…"
            navigationItem.title = "時間割"
        } else {
            navigationItem.rightBarButtonItem?.title = "完了"
            navigationItem.title = "時間割(変更中)"
        }

    }
    
    //コレクションビューのセクション数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    //データの個数（DataSourceを設定した場合に必要な項目）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return numOfDays
    }
    
    //データを返すメソッド（DataSourceを設定した場合に必要な項目）
    //動作確認の為セルの背景を変える。曜日については表示する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //コレクションビューから識別子「CalendarCell」のセルを取得する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScheduleViewCell
        if(indexPath.section == 0) { //曜日表示
            cell.textLabel.text = weekArray[indexPath.row]
        }else if(indexPath.row % 7 == 0 && indexPath.section != 0) {
            cell.textLabel.text = String(indexPath.section)
        } else {
            for schedule in scheduleArray {
                if schedule["weekRow"] as! Int == indexPath.row && schedule["timeSection"] as! Int == indexPath.section {
                    cell.textLabel.text = schedule["subject"] as? String
                }
            }
        }
        print(cell.frame)
        return cell
    }
    
    //セルをクリックしたら呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)  as! ScheduleViewCell
        print("Num：\(indexPath.row) Section:\(indexPath.section)")
        if number % 2 != 0 {
            let alert = UIAlertController(title: "時間割追加", message: "文字を入力してください", preferredStyle: .alert)
            // OKボタンの設定
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (action:UIAlertAction!) -> Void in
                var newSchedules: [[String: Any]] = []
                for schedule in self.scheduleArray {
                    if schedule["weekRow"] as! Int == indexPath.row && schedule["timeSection"] as! Int == indexPath.section {
                    } else {
                        newSchedules.append(schedule)
                    }
                }
                self.scheduleArray = newSchedules
                // OKを押した時入力されていたテキストを表示
                if let textFields = alert.textFields {
                    // アラートに含まれるすべてのテキストフィールドを調べる
                    for textField in textFields {
                        self.userDefaults.removeObject(forKey: "Schedule")
                        print(textField.text!)
                        cell.textLabel.text = textField.text!
                        self.scheduleArray.append(["weekRow": indexPath.row, "timeSection": indexPath.section, "subject": textField.text!])
                        self.userDefaults.set(self.scheduleArray, forKey: "Schedule")
                        print(self.scheduleArray)
                    }
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
    }
    
    /*
     
     セルのレイアウト設定
     
     */
    //セルサイズの指定（UICollectionViewDelegateFlowLayoutで必須）　横幅いっぱいにセルが広がるようにしたい
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 8.0
        let widths:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(numOfDays)
        var heights:CGFloat = CGFloat()
        if(indexPath.section == 0) {
            heights = widths * 0.8
        } else {
            heights = widths * 1.5
        }
        return CGSize(width:widths,height:heights)
    }
    
    //セルのアイテムのマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0 )  //マージン(top , left , bottom , right)
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
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
