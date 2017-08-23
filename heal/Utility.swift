//
//  Utility.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/19.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static func dateToString(date:Date) ->String {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
        let date_formatter: DateFormatter = DateFormatter()
        var weekdays: [String]  = [ "日", "月", "火", "水", "木", "金", "土"]
        date_formatter.locale     = Locale(identifier: "ja")
        date_formatter.dateFormat = "yyyy年MM月dd日 "
        return date_formatter.string(from: date) + "(\(weekdays[comps.weekday! - 1]))"
    }
    
}
