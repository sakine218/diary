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
        textLabel = UILabel()
        textLabel.textAlignment = NSTextAlignment.center
        // Cellに追加
        self.addSubview(textLabel)
        // Initialization code
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
