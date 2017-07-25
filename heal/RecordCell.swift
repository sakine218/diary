//
//  RecordCell.swift
//  heal
//
//  Created by 西林咲音 on 2017/07/25.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class RecordCell: UICollectionViewCell {
    
    var textLabel : UILabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width,  height: self.frame.height))
        textLabel.textAlignment = NSTextAlignment.center
        // Cellに追加
        self.addSubview(textLabel)
        // Initialization code
    }

}
