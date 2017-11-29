//
//  CalendarCell.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/14.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    @IBOutlet var textLabel:UILabel!
    @IBOutlet var cellBgView: UIView!
    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        cellBgView.layer.shadowColor = AppColors.lightGray.cgColor /* 影の色 */
        cellBgView.layer.shadowOffset = CGSize(width: 10.0, height: 10.0) /* 影の大きさ */
        cellBgView.layer.shadowOpacity = 0.5 /* 透明度 */
        cellBgView.layer.shadowRadius = 10.0 /* 影の距離 */
        //UILabelを生成
    }
}
