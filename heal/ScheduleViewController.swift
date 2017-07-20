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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var number: Int = 0
    let weekArray = ["","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let numOfDays = 7
    let cellMargin : CGFloat = 2.0
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeButton(_ sender: Any) {
        number = number + 1
        if number % 2 == 0 {
            changeButton.setTitle("変更", for: UIControlState.normal)
            titleLabel.text = "時間割"
        } else {
            changeButton.setTitle("完了", for: UIControlState.normal)
            titleLabel.text = "時間割(変更中)"
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //コレクションビューのセクション数　今回は2つに分ける
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScheduleCell
        if(indexPath.section == 0) {             //曜日表示
            cell.backgroundColor = UIColor.red
            cell.textLabel.text = weekArray[indexPath.row]
        }else if(indexPath.row % 7 == 0 && indexPath.section != 0) {
            cell.backgroundColor = UIColor.red
            cell.textLabel.text = String(indexPath.section)
        }
        return cell
    }
    
    //セルをクリックしたら呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num：\(indexPath.row) Section:\(indexPath.section)")
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
