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
    
    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        //UILabelを生成
        
    }
}
