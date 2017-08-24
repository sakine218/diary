//
//  AddDiaryViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var dateTextField: UITextField = UITextField()
    var toolBar: UIToolbar = UIToolbar()
    var datePicker: UIDatePicker = UIDatePicker()
    let toolBarBtn      = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(tappedToolBarBtn(sender:)))
    let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .plain, target: self, action: #selector(tappedToolBarBtnToday(sender:)))
    let label1: UILabel = UILabel()
    let label2: UILabel = UILabel()
    let label3: UILabel = UILabel()
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
    var cellTapNumArray: [Int] = [0, 0, 0, 0, 0, 0]
    let cellTapColorArray: [UIColor] = [UIColor.white, AppColors.pink, AppColors.sky, AppColors.yellow]
    var buttonArray: [UIButton] = []
    //var attendanceArray: [[String: Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        scrollView.showsVerticalScrollIndicator = false
        addShadowView()
        addView()
        addDateTextField()
        addLabels()
        addSlider()
        addTextView()
        addChangeButton()
        addSwitch()
        addOkButton()
        addExplainLabels()
        addButtons()
        navigationItem.title = "新規作成"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        first()
        let calendar = Calendar.current
        let date = Date()
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
        setButtonTitles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func first() {
        redValue = 180
        greenValue = 255
        blueValue = 255
        slider.value = 0
        bgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
        textView.text = ""
        datePicker.date = Date()
        changeLabelDate(date: Date())
        setButtonTitles()
    }
    
    func addShadowView() {
        let shadowView: UIView = UIView()
        shadowView.frame = CGRect(x:2,y:2,width:self.view.frame.width - 32,height:990)
        shadowView.center.x = self.view.center.x + 2
        shadowView.cornerRadius = 20
        shadowView.backgroundColor = AppColors.lightGray
        shadowView.layer.opacity = 0.6
        scrollView.addSubview(shadowView)
    }
    
    func addView() {
        bgView.frame = CGRect(x:0,y:0,width:self.view.frame.width - 32,height:990)
        bgView.center.x = self.view.center.x
        bgView.cornerRadius = 20
        bgView.backgroundColor = UIColor(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha:1.0)
        scrollView.addSubview(bgView)
    }
    
    func addDateTextField() {
        // 入力欄の設定
        dateTextField.backgroundColor = UIColor.white
        dateTextField.cornerRadius = 7
        dateTextField.minimumFontSize = 20
        dateTextField.frame = CGRect(x: 0,y: 20,width: self.view.frame.width - 168, height: 50)
        dateTextField.center.x = self.view.center.x
        dateTextField.placeholder = Utility.dateToString(date: Date())
        dateTextField.text = "　 " + Utility.dateToString(date: Date())
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
        datePicker.maximumDate = Date()
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
        let calendar = Calendar.current
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
        setButtonTitles()
        dateTextField.resignFirstResponder()
    }
    
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(sender: UIBarButtonItem) {
        datePicker.date = Date()
        changeLabelDate(date: Date())
    }
    func changedDateEvent(sender:UIDatePicker){
        self.changeLabelDate(date: datePicker.date)
    }
    
    func changeLabelDate(date:Date) {
        dateTextField.text = " 　" + Utility.dateToString(date: date)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        //print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        print("beginDragging")
    }
    
    func addLabels() {
        let textArray: [String] = ["症状","Note","Schedule"]
        label1.text = textArray[0]
        label1.frame = CGRect(x: 44, y: 80, width: 285, height: 50)
        label2.text = textArray[1]
        label2.frame = CGRect(x: 44, y: 160, width: 285, height: 50)
        label3.text = textArray[2]
        label3.frame = CGRect(x: 44, y: 420, width: 285, height: 50)
        self.scrollView.addSubview(label1)
        self.scrollView.addSubview(label2)
        self.scrollView.addSubview(label3)
    }
    
    func addSlider() {
        slider.frame = CGRect(x: 0, y: 100, width: self.view.frame.width - 88, height: 80)
        slider.center.x = self.view.center.x
        slider.addTarget(self, action: #selector(changeSlider(_:)) , for: .valueChanged)
        self.scrollView.addSubview(slider)
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
    
    func addTextView() {
        textView.frame = CGRect(x: 44, y: 210, width: 285, height: 200)
        textView.cornerRadius = 10
        self.scrollView.addSubview(textView)
    }
    
    func addChangeButton() {
        let changeButton: UIButton = UIButton()
        changeButton.frame = CGRect(x: 210, y: 430, width: 60, height: 30)
        changeButton.setTitle("変更", for: .normal)
        changeButton.setTitleColor(UIColor.black, for: .normal)
        changeButton.backgroundColor = UIColor.white
        changeButton.cornerRadius = 7
        self.scrollView.addSubview(changeButton)
    }
    
    func addSwitch() {
        let scheduleSwitch: UISwitch = UISwitch()
        scheduleSwitch.isOn = true
        scheduleSwitch.frame = CGRect(x: 284, y: 430, width: 50, height: 50)
        self.scrollView.addSubview(scheduleSwitch)
    }
    
    func addButtons() {
        for i in 0...5{
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 480 + 60 * i, width: Int(self.view.frame.width - 148), height: 60)
            button.center.x = self.view.center.x
            button.backgroundColor = UIColor.white
            button.tag = i
            buttonArray.append(button)
            button.addTarget(self, action: #selector(scheduleButtonEvent(sender:)), for: .touchUpInside)
            self.scrollView.addSubview(button)
        }
    }
    
    func scheduleButtonEvent(sender: UIButton) {
        cellTapNumArray[sender.tag]  += 1
        sender.borderWidth = 3
        sender.borderColor = cellTapColorArray[cellTapNumArray[sender.tag] % 4]
    }
    
    func setButtonTitles() {
        for (index, button) in buttonArray.enumerated() {
            for day in dayArray {
                if day["timeSection"] as! Int == index + 1 {
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.setTitle(day["subject"] as? String, for: .normal)
                    button.borderWidth = 3
                    button.borderColor = cellTapColorArray[0]
                    cellTapNumArray = [0, 0, 0, 0, 0, 0]
                }
            }
        }
        
        for button in buttonArray {
            if button.titleLabel?.text == nil {
                button.isUserInteractionEnabled = false
            } else {
                button.isUserInteractionEnabled = true
            }
        }
    }
    
    func addExplainLabels() {
        let labelTextArray: [String] = ["遅刻", "早退", "欠課"]
        var labelArray: [UILabel] = []
        let stackView: UIStackView = UIStackView()
        stackView.frame = CGRect(x: 0, y: 855, width: self.view.frame.width - 148, height: 30)
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
    
    func addOkButton() {
        let okButton: UIButton = UIButton()
        okButton.frame = CGRect(x: 140, y: 910, width: 100, height: 50)
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(UIColor.black, for: .normal)
        okButton.backgroundColor = UIColor.white
        okButton.cornerRadius = 7
        okButton.addTarget(self, action: #selector(buttonEvent(sender:)), for: .touchUpInside)
        self.scrollView.addSubview(okButton)
    }
    
    func buttonEvent(sender: UIButton) {
        
        let content = Content(date: Utility.dateToString(date: datePicker.date), note: textView.text, redValue: Float(redValue), greenValue: Float(greenValue), blueValue: Float(blueValue), attendanceArray: dayArray, tapArray: cellTapNumArray)
        content.save()
        
        //覚え書き
        //　全部取得
        //let allContents = Content.findAll()
        //　日付検索
        //let dateContents = Content.find(withId: "8/2")
        
        let alert = UIAlertController(
            title: "完了",
            message: "投稿が完了しました！",
            preferredStyle: .alert)
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print(content)
            self.first()
            self.setButtonTitles()
        }))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
