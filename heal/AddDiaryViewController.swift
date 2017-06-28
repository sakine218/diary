//
//  AddDiaryViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController, UIScrollViewDelegate, UIToolbarDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var dateTextField: UITextField = UITextField()
    var toolBar: UIToolbar = UIToolbar()
    var datePicker: UIDatePicker = UIDatePicker()
    let toolBarBtn      = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(tappedToolBarBtn(sender:)))
    let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .plain, target: self, action: #selector(tappedToolBarBtnToday(sender:)))
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.contentSize = CGSize(width: 343, height: 1000)
        addView()
        addDateTextField()
                // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addView() {
        let view: UIView = UIView()
        view.frame = CGRect(x:16,y:0,width:343,height:980)
        view.cornerRadius = 20
        view.backgroundColor = UIColor.red
        scrollView.addSubview(view)
    }
    
    func addDateTextField() {
        // 入力欄の設定
        dateTextField.backgroundColor = UIColor.white
        dateTextField.cornerRadius = 7
        dateTextField.frame = CGRect(x: 84,y: 20,width: 200, height: 20)
        dateTextField.placeholder = dateToString(date: Date())
        dateTextField.text = dateToString(date: Date())
        self.scrollView.addSubview(dateTextField)
        addDatePicker()
        addToolBar()
    }
    
    func addDatePicker() {
        // UIDatePickerの設定
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(changedDateEvent(sender:)), for: UIControlEvents.valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = datePicker
    }
    
    func addToolBar() {
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.white
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtn, toolBarBtnToday]
        dateTextField.inputAccessoryView = toolBar
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        datePicker.date = Date()
        changeLabelDate(date: Date())
    }
    
    //
    func changedDateEvent(sender:UIDatePicker){
        self.changeLabelDate(date: datePicker.date)
    }
    
    func changeLabelDate(date:Date) {
        dateTextField.text = self.dateToString(date: date)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        print("beginDragging")
    }
    
    func dateToString(date:Date) ->String {
        let calender: Calendar = Calendar(identifier: .gregorian)
        let comps = calender.dateComponents([.year, .month, .day, .weekday], from: date)
        let date_formatter: DateFormatter = DateFormatter()
        var weekdays: [String]  = [ "日", "月", "火", "水", "木", "金", "土"]
        
        date_formatter.locale     = Locale(identifier: "ja")
        date_formatter.dateFormat = "　yyyy年MM月dd日 "
        
        return date_formatter.string(from: date) + "(\(weekdays[comps.weekday! - 1]))"
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
