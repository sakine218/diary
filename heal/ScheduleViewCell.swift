//
//  ScheduleViewCell.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/23.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class ScheduleViewCell: UICollectionViewCell {
    
    var textLabel : UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(textLabel)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // Cellに追加
        
        // Initialization code
    }
    
}
