//
//  AddDiaryViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//
import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var dateTextField: UITextField = UITextField()
    var datePicker: UIDatePicker = UIDatePicker()
    let slider: UISlider = UISlider()
    let bgView: UIView = UIView()
    var redValue: CGFloat = 180
    var greenValue: CGFloat = 255
    var blueValue: CGFloat = 255
    let textView: UITextView = UITextView()
    let userDefaults = UserDefaults.standard
    var scheduleArray: [[String: Any]] = []
    var dayNum: Int = 0
    var dayArray: [[String: Any]] = []
    var cellTapNumArray: [Int] = [0, 0, 0, 0, 0, 0, 0]
    let cellTapColorArray: [UIColor] = [UIColor.white, AppColors.pink, AppColors.sky, AppColors.yellow]
    var subjectButtonArray: [UIButton] = []
    var dayText: String? // nilじゃなければ、編集モード
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1070)
        scrollView.showsVerticalScrollIndicator = false
        setup()
        navigationItem.title = "作成"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        if (userDefaults.array(forKey: "Schedule") != nil) {
            scheduleArray = userDefaults.array(forKey: "Schedule") as! [[String : Any]]
        }
        dayArray.removeAll()
        for schedule in scheduleArray {
            if schedule["weekRow"] as! Int == dayNum {
                self.dayArray.append(schedule)
            }
        }
        setButtonTitles()
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func finishToolBarButtonEvent(_ sender: UIBarButtonItem) {
        let date = datePicker.date
        dayNum = calendar.component(.weekday, from: date) - 1
        if (userDefaults.array(forKey: "Schedule") != nil) {
            scheduleArray = userDefaults.array(forKey: "Schedule") as! [[String : Any]]
        }
        dayArray.removeAll()
        for schedule in scheduleArray {
            if schedule["weekRow"] as! Int == dayNum {
                self.dayArray.append(schedule)
            }
        }
        dateTextField.text = Utility.dateToString(date: datePicker.date)
        dayText = dateTextField.text
        if let content = Content.find(withId: dayText!).first {
            dayNum = calendar.component(.weekday, from: Utility.stringToDate(from: dayText!)) - 1
            redValue = CGFloat(content.redValue)
            greenValue = CGFloat(content.greenValue)
            blueValue = CGFloat(content.blueValue)
            slider.value = content.value
            datePicker.date = Utility.stringToDate(from: dayText!)
            dateTextField.text = Utility.dateToString(date: Utility.stringToDate(from: dayText!))
            textView.text = content.note
            bgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
            for (index, _) in content.attendanceArray.enumerated() {
                cellTapNumArray[index] = content.attendanceArray[index].tapNum
            }
            print(cellTapNumArray)
            for i in 0...6 {
                subjectButtonArray[i].backgroundColor = cellTapColorArray[cellTapNumArray[i] % 4]
            }
        }
        setButtonTitles()
        dateTextField.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func todayToolBarButtonEvent(_ sender: UIBarButtonItem) {
        datePicker.date = Date()
        dateTextField.text = Utility.dateToString(date: Date())
    }
    func datePickerEvent(sender:UIDatePicker){
        dateTextField.text = Utility.dateToString(date: datePicker.date)
    }
    
    func changeSlider(_ sender: UISlider) {
        if sender.value <= 0.5 {
            redValue = 180 + CGFloat(sender.value * 150 )
            blueValue = 255 - CGFloat(sender.value * 250)
        } else {
            greenValue = 255 - CGFloat(sender.value - 0.5) * 210
        }
        bgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
    }
    
    func scheduleButtonEvent(sender: UIButton) {
        cellTapNumArray[sender.tag]  += 1
        sender.backgroundColor = cellTapColorArray[cellTapNumArray[sender.tag] % 4]
        if cellTapNumArray[sender.tag] % 4 == 0 {
            sender.setTitleColor(AppColors.gray, for: .normal)
        } else {
            sender.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    func setButtonTitles() {
        for (index, button) in subjectButtonArray.enumerated() {
            button.setTitle("", for: .normal)
            button.isEnabled = false
            for day in dayArray {
                if day["timeSection"] as! Int == index + 1 {
                    button.setTitleColor(AppColors.gray, for: .normal)
                    button.setTitle(day["subject"] as? String, for: .normal)
                    button.isEnabled = true
                }
            }
        }
    }
    
    func okButtonEvent(sender: UIButton) {
        print(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")
        let realm = try! Realm()
        // すでに選んだ日付にデータがあれば上書き
        // 編集モード
        if let dayText = self.dayText {
            // 日付を変えずに編集
            if
                dayText == Utility.dateToString(date: datePicker.date),
                let selectedContent: Content = realm.objects(Content.self).filter("date == %@", Utility.dateToString(date: datePicker.date)).first {
                try! realm.write {
                    realm.delete(selectedContent.attendanceArray)
                    selectedContent.note = textView.text
                    selectedContent.redValue = Float(redValue)
                    selectedContent.greenValue = Float(greenValue)
                    selectedContent.blueValue = Float(blueValue)
                    selectedContent.value = Float(slider.value)
                    for (index, item) in dayArray.enumerated() {
                        let attendance: Attendance = Attendance()
                        attendance.id = Attendance.lastId() + index
                        attendance.subjectText = item["subject"] as! String
                        attendance.tapNum = cellTapNumArray[index]
                        selectedContent.attendanceArray.append(attendance)
                    }
                    realm.add(selectedContent, update: true)
                }
                let alert = UIAlertController(
                    title: "完了",
                    message: "投稿が完了しました！",
                    preferredStyle: .alert)
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.tabBarController?.selectedIndex = 0
                }))
                // アラート表示
                self.present(alert, animated: true, completion: nil)
            }
            else { // 日付を変えて編集モード
                // 既存のデータを削除
                if let selectedContent = realm.objects(Content.self).filter("date == %@", dayText).first {
                    selectedContent.delete()
                }
                let content = Content(date: Utility.dateToString(date: datePicker.date), note: textView.text, redValue: Float(redValue), greenValue: Float(greenValue), blueValue: Float(blueValue), value: Float(slider.value), attendanceArray: dayArray, tapArray: cellTapNumArray)
                content.save()
                let alert = UIAlertController(
                    title: "完了",
                    message: "投稿が完了しました！",
                    preferredStyle: .alert)
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.tabBarController?.selectedIndex = 0
                }))
                // アラート表示
                self.present(alert, animated: true, completion: nil)
            }
        }
        else { // 新規追加
            let content = Content(date: Utility.dateToString(date: datePicker.date), note: textView.text, redValue: Float(redValue), greenValue: Float(greenValue), blueValue: Float(blueValue), value: Float(slider.value), attendanceArray: dayArray, tapArray: cellTapNumArray)
            content.save()
            let alert = UIAlertController(
                title: "完了",
                message: "投稿が完了しました！",
                preferredStyle: .alert)
            // アラートにボタンをつける
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.tabBarController?.selectedIndex = 0
            }))
            // アラート表示
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setup() {
        let shadowView: UIView = UIView()
        shadowView.frame = CGRect(x:2,y:12,width:self.view.frame.width - 32,height:1050)
        shadowView.center.x = self.view.center.x + 2
        shadowView.cornerRadius = 20
        shadowView.backgroundColor = AppColors.lightGray
        shadowView.layer.opacity = 0.6
        scrollView.addSubview(shadowView)
        
        bgView.frame = CGRect(x:0,y:10,width:self.view.frame.width - 32,height:1050)
        bgView.center.x = self.view.center.x
        bgView.cornerRadius = 20
        bgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
        scrollView.addSubview(bgView)
        
        // 入力欄の設定
        dateTextField.backgroundColor = UIColor.white
        dateTextField.cornerRadius = 7
        dateTextField.minimumFontSize = 20
        dateTextField.textAlignment = NSTextAlignment.center
        dateTextField.frame = CGRect(x: 0,y: 20,width: Int(self.view.frame.width / 1.5), height: 50)
        dateTextField.center.x = self.view.center.x
        dateTextField.placeholder = Utility.dateToString(date: Date())
        dateTextField.text = Utility.dateToString(date: Date())
        self.scrollView.addSubview(dateTextField)
        
        // UIDatePickerの設定
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(datePickerEvent(sender:)), for: UIControlEvents.valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = datePicker
        datePicker.maximumDate = Date()
        
        // UIDatePickerの設定
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(datePickerEvent(sender:)), for: UIControlEvents.valueChanged)
        datePicker.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = datePicker
        datePicker.maximumDate = Date()
        
        // UIToolBarの設定
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.white
        let finishToolBarButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(finishToolBarButtonEvent(_:)))
        let todayToolBarButton = UIBarButtonItem(title: "今日", style: .plain, target: self, action: #selector(todayToolBarButtonEvent(_:)))
        toolBar.items = [finishToolBarButton, todayToolBarButton]
        dateTextField.inputAccessoryView = toolBar
        let textArray: [String] = ["症状(軽 ↔︎ 重)","日記","時間割"]
        let label1: UILabel = UILabel()
        label1.text = textArray[0]
        label1.frame = CGRect(x: 44, y: 80, width: 285, height: 50)
        let label2: UILabel = UILabel()
        label2.text = textArray[1]
        label2.frame = CGRect(x: 44, y: 160, width: 285, height: 50)
        let label3: UILabel = UILabel()
        label3.text = textArray[2]
        label3.frame = CGRect(x: 44, y: 420, width: 285, height: 50)
        self.scrollView.addSubview(label1)
        self.scrollView.addSubview(label2)
        self.scrollView.addSubview(label3)
        
        slider.frame = CGRect(x: 0, y: 100, width: self.view.frame.width - 88, height: 80)
        slider.center.x = self.view.center.x
        slider.addTarget(self, action: #selector(changeSlider(_:)) , for: .valueChanged)
        self.scrollView.addSubview(slider)
        
        textView.frame = CGRect(x: 0, y: 210, width: Int(self.view.frame.width / 1.5), height: 200)
        textView.center.x = self.view.center.x
        textView.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 15)
        self.scrollView.addSubview(textView)
        
        for i in 0...6{
            let button = UIButton()
            button.setTitleColor(AppColors.gray, for: .normal)
            button.frame = CGRect(x: 0, y: 480 + 60 * i, width: Int(self.view.frame.width - 148), height: 60)
            button.center.x = self.view.center.x
            button.backgroundColor = UIColor.white
            button.tag = i
            subjectButtonArray.append(button)
            button.addTarget(self, action: #selector(scheduleButtonEvent(sender:)), for: .touchUpInside)
            self.scrollView.addSubview(button)
            
            let okButton: UIButton = UIButton()
            okButton.frame = CGRect(x: 0, y: 970, width: 100, height: 50)
            okButton.center.x = self.view.center.x
            okButton.setTitle("OK", for: .normal)
            okButton.setTitleColor(UIColor.black, for: .normal)
            okButton.backgroundColor = UIColor.white
            okButton.cornerRadius = 7
            okButton.addTarget(self, action: #selector(okButtonEvent(sender:)), for: .touchUpInside)
            self.scrollView.addSubview(okButton)
        }
        
        let labelTextArray: [String] = ["遅刻", "早退", "欠課"]
        var labelArray: [UILabel] = []
        let stackView: UIStackView = UIStackView()
        stackView.frame = CGRect(x: 0, y: 915, width: self.view.frame.width - 148, height: 30)
        stackView.center.x = self.view.center.x
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        for i in 0...2 {
            let label: UILabel = UILabel()
            label.text = labelTextArray[i]
            label.textAlignment = NSTextAlignment.center
            label.backgroundColor = cellTapColorArray[i + 1]
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            labelArray.append(label)
            stackView.addArrangedSubview(label)
        }
        scrollView.addSubview(stackView)
    }
    
    func setupUI() {
        var date = Date()
        bgView.backgroundColor = UIColor(red: 180 / 255, green: 255 / 255, blue: 255 / 255, alpha:1.0)
        if let dayText = dayText {
            date = Utility.stringToDate(from: dayText)
        }
        print(date)
        dayNum = calendar.component(.weekday, from: date) - 1
        textView.text = ""
        slider.value = 0
        datePicker.date = date
        dateTextField.text = Utility.dateToString(date: date)
        for i in 0...6 {
            subjectButtonArray[i].backgroundColor = cellTapColorArray[0]
        }
        cellTapNumArray = [0, 0, 0, 0, 0, 0, 0]
        setButtonTitles()
        for i in 0...6 {
            subjectButtonArray[i].backgroundColor = cellTapColorArray[0]
            cellTapNumArray[i] = 0
        }
        if let dayText = self.dayText, let content = Content.find(withId: dayText).first {
            dayNum = calendar.component(.weekday, from: Utility.stringToDate(from: dayText)) - 1
            redValue = CGFloat(content.redValue)
            greenValue = CGFloat(content.greenValue)
            blueValue = CGFloat(content.blueValue)
            slider.value = content.value
            datePicker.date = Utility.stringToDate(from: dayText)
            dateTextField.text = Utility.dateToString(date: Utility.stringToDate(from: dayText))
            textView.text = content.note
            bgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
            for (index, _) in content.attendanceArray.enumerated() {
                cellTapNumArray[index] = content.attendanceArray[index].tapNum
            }
            print(cellTapNumArray)
            for i in 0...6 {
                subjectButtonArray[i].backgroundColor = cellTapColorArray[cellTapNumArray[i] % 4]
            }
        } else {
            slider.value = 0
            bgView.backgroundColor = UIColor(red: 180 / 255, green: 255 / 255, blue: 255 / 255, alpha:1.0)
            textView.text = ""
        }
    }
    
}
