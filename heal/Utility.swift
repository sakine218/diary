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
        date_formatter.locale = Locale(identifier: "ja")
        date_formatter.dateFormat = "yyyy年MM月dd日 "
        return date_formatter.string(from: date) + "(\(weekdays[comps.weekday! - 1]))"
    }
    
    static func stringToDate(from dateString: String) ->Date {
        var dayString: String = dateString
        var startIndex = dayString.index(dayString.startIndex, offsetBy: 12)
        var endIndex = dayString.index(dayString.endIndex, offsetBy: -0)
        var range = startIndex..<endIndex
        dayString.removeSubrange(range)
        print(dayString)
        let date_formatter: DateFormatter = DateFormatter()
        date_formatter.locale = Locale(identifier: "ja")
        date_formatter.dateFormat = "yyyy年MM月dd日 "
        let date: Date = date_formatter.date(from: dayString)!
        print(date)
        return date
    }
    
}
