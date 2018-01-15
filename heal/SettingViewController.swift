//
//  SettingViewController.swift
//  heal
//
//  Created by 西林咲音 on 2017/07/12.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit
import EAIntroView

class SettingViewController: UIViewController {
    
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var howButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "設定"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func howButton(_ sender: Any) {
        showTutorial()
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        let alert = UIAlertController(
            title: "レビューを書く",
            message: "ぜひご意見をお聞かせください",
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "書く", style: .default, handler: { action in
            print("OK")
        }))
        
        alert.addAction(UIAlertAction(title: "また今度", style: .cancel))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    func showTutorial() {
        // basic
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
        
        //intro.setDelegate:self
        
        intro.show(in: self.view.window, animateDuration: 0.6)
        
        // チュートリアルを見たことを記録する
        //UserDefaults.standard.set(1, forKey: "active")
        
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
