//
//  DiaryCell.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/21.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class DiaryCell: UITableViewCell {
    
    @IBOutlet var BGView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        BGView.cornerRadius = 15
        BGView.backgroundColor = UIColor.red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
