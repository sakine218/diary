//
//  ViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/11.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit
import EAIntroView

class ViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var myCollectView: UICollectionView!
    
    //セルの余白
    let cellMargin:CGFloat = 0.0
    //１週間に何日あるか(行数)
    let daysPerWeek:Int = 7
    let dateManager = DateManager()
    var startDate:Date!
    var dateText: String = String()
    private var monthLabel:UILabel!
    let ud = UserDefaults.init()
    
    override func viewWillAppear(_ animated: Bool) {
        myCollectView.showsVerticalScrollIndicator = false
        myCollectView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "collectCell")
        myCollectView.delegate = self
        myCollectView.dataSource = self
        myCollectView.backgroundColor = .white
        startDate = Date()
        
        //checker = userDefault.bool(forKey: "firstLaunch")
        
        let ym:Int = Int(dateManager.ymTag(row: 6))!
        let digit = numberOfDigit(ym: ym)
        
        if(digit == 5){
            navigationItem.title = String(ym / 10) + "年" + String(ym % 10) + "月"
        }else if(digit == 6){
            navigationItem.title = String(ym / 100) + "年" + String(ym % 100) + "月"
        }
        /*let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction(sender:)))
         longPressRecognizer.allowableMovement = 10
         longPressRecognizer.minimumPressDuration = 1.0
         myCollectView.addGestureRecognizer(longPressRecognizer)
         */
        myCollectView.reloadData()
        
        print("起動は\(ud.bool(forKey: "firstLaunch"))")
        if ud.bool(forKey: "firstLaunch") {
            // 初回起動時の処理
            showTutorial()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myCollectView.scrollToItem(at: IndexPath(item: dateManager.numberOfItems() - 1, section: 0) , at: .bottom, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showTutorial() {
        let page1: EAIntroPage = EAIntroPage()
        let page2: EAIntroPage = EAIntroPage()
        let page3: EAIntroPage = EAIntroPage()
        let page4: EAIntroPage = EAIntroPage()
        let page5: EAIntroPage = EAIntroPage()
        
        page1.bgImage = UIImage(named: "walk_0.jpg")
        page2.bgImage = UIImage(named: "walk_1.jpg")
        page3.bgImage = UIImage(named: "walk_2.jpg")
        page4.bgImage = UIImage(named: "walk_3.jpg")
        page5.bgImage = UIImage(named: "walk_4.jpg")
        
        let intro :EAIntroView = EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3,page4,page5])
        
        intro.skipButton.setTitleColor(AppColors.gray, for: UIControlState.normal)
        
        intro.show(in: self.view.window, animateDuration: 0.6)
        
        // 2回目以降の起動では「firstLaunch」のkeyをfalseに
        ud.set(false, forKey: "firstLaunch")
    }
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumInteritemSpacingForSectionAt section:Int) -> CGFloat{
        return cellMargin
    }
    
    //セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //セルのサイズを設定
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize{
        let numberOfMargin:CGFloat = 8.0
        let width:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height:CGFloat = width * 1.2
        return CGSize(width:width,height:height)
    }
    
    //選択した時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        if cell.cellBgView.backgroundColor != .white {
            dateText = Utility.dateToString(date: dateManager.dateForCellAtIndexPathWeeks(row: indexPath.item))
            print(dateText)
            self.segue()
        }
    }
    
    func segue() {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! DetailViewController
        VC.dateText = dateText
    }
    
    //セルの総数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateManager.numberOfItems()
    }
    
    //セルの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier:"collectCell",for:indexPath as IndexPath) as! CalendarCell
        
        //土曜日は赤　日曜日は青　にテキストカラーを変更する
        if(indexPath.item % 7 == 0){
            cell.textLabel.textColor = AppColors.red
        }else if(indexPath.item % 7 == 6){
            cell.textLabel.textColor = AppColors.blue
        }else{
            cell.textLabel.textColor = AppColors.gray
        }
        cell.tag = Int(dateManager.ymTag(row: indexPath.item))!
        //セルの日付を取得し
        cell.textLabel.numberOfLines = 4
        let day = Int(dateManager.conversionDateFormat(row: indexPath.item))!
        let month = Int(dateManager.monthTag(row: indexPath.item))!
        cell.textLabel.text = "  " + "\(day)" + " \n \n"
        if (day == 1) {
            cell.textLabel.text = "  " + "\(month)" + "/" + "\(day)" + " \n \n"
        }
        if(day <= 7) {
        }
        let dayText: String = Utility.dateToString(date: dateManager.dateForCellAtIndexPathWeeks(row: indexPath.item))
        //print(dayText)
        if let content = Content.find(withId: dayText).first {
            let redValue: CGFloat = CGFloat(content.redValue)
            let greenValue: CGFloat = CGFloat(content.greenValue)
            let blueValue: CGFloat = CGFloat(content.blueValue)
            cell.cellBgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
        } else {
            cell.cellBgView.backgroundColor = .white
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleCell = myCollectView.visibleCells.filter{
            return myCollectView.bounds.contains($0.frame)
        }
        
        var visibleCellTag = Array<Int>()
        if(visibleCell != []){
            visibleCellTag = visibleCell.map{ $0.tag }
            //月は奇数か偶数か　割り切れるものだけを取り出す
            let even = visibleCellTag.filter{
                return $0 % 2 == 0
            }
            let odd = visibleCellTag.filter{
                return $0 % 2 != 0
            }
            //oddかevenの多い方を返す
            let ym = even.count >= odd.count ? even[0] : odd[0]
            
            //桁数によって分岐
            let digit = numberOfDigit(ym: ym)
            if(digit == 5){
                navigationItem.title = String(ym / 10) + "年" + String(ym % 10) + "月"
            }else if(digit == 6){
                navigationItem.title = String(ym / 100) + "年" + String(ym % 100) + "月"
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if myCollectView.contentOffset.y <= 0,
            let visibleCell = myCollectView.visibleCells.first {
            self.dateManager.paging += 1
            self.myCollectView.reloadData()
            self.myCollectView.performBatchUpdates({}, completion: { [weak self] isFinished in
                
                if isFinished {
                    if let indexPath = self?.myCollectView.indexPath(for: visibleCell) {
                        
                        self?.myCollectView.scrollToItem(at: indexPath, at: .top, animated: false)
                    }
                }
            })
        }
    }
    
    func numberOfDigit(ym:Int) -> Int{
        var num = ym
        var cnt = 1
        while(num / 10 != 0){
            cnt = cnt + 1
            num = num / 10
        }
        return cnt
        
    }
}


extension UIView {
    
    enum BorderPosition {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    func border(borderWidth: CGFloat, borderColor: UIColor?, borderRadius: CGFloat?) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        if let _ = borderRadius {
            self.layer.cornerRadius = borderRadius!
        }
        self.layer.masksToBounds = true
    }
    
    func border(positions: [BorderPosition], borderWidth: CGFloat, borderColor: UIColor?) {
        
        let topLine = CALayer()
        let leftLine = CALayer()
        let bottomLine = CALayer()
        let rightLine = CALayer()
        
        self.layer.sublayers = nil
        self.layer.masksToBounds = true
        
        if let _ = borderColor {
            topLine.backgroundColor = borderColor!.cgColor
            leftLine.backgroundColor = borderColor!.cgColor
            bottomLine.backgroundColor = borderColor!.cgColor
            rightLine.backgroundColor = borderColor!.cgColor
        } else {
            topLine.backgroundColor = UIColor.white.cgColor
            leftLine.backgroundColor = UIColor.white.cgColor
            bottomLine.backgroundColor = UIColor.white.cgColor
            rightLine.backgroundColor = UIColor.white.cgColor
        }
        
        if positions.contains(.Top) {
            topLine.frame = CGRect(x:0.0, y:0.0, width:self.frame.width, height:borderWidth)
            self.layer.addSublayer(topLine)
        }
        if positions.contains(.Left) {
            leftLine.frame = CGRect(x:0.0,y: 0.0, width:borderWidth,height: self.frame.height)
            self.layer.addSublayer(leftLine)
        }
        if positions.contains(.Bottom) {
            bottomLine.frame = CGRect(x:0.0,y: self.frame.height - borderWidth, width:self.frame.width, height:borderWidth)
            self.layer.addSublayer(bottomLine)
        }
        if positions.contains(.Right) {
            rightLine.frame = CGRect(x:self.frame.width - borderWidth, y:0.0,width: borderWidth, height:self.frame.height)
            self.layer.addSublayer(rightLine)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let _ = self.layer.borderColor {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            return nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}

