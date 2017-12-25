//
//  DateManager.swift
//  heal
//
//  Created by 西林咲音 on 2017/06/14.
//  Copyright © 2017年 西林咲音. All rights reserved.
//
import UIKit

class DateManager {
    
    //現在の日付
    private var date = Date()
    
    var paging: Int = 1
    
    private var number: Int = 0
    
    private var calendar = Calendar.current
    
    private var dayDateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "d"
        return formatter
    }
    
    private var yDateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "Y"
        return formatter
    }
    
    private var mDateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M"
        return formatter
    }
    
    private var ymDateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YM"
        return formatter
    }
    
    init() {
        calendar.locale = Locale(identifier: "ja_JP")
        date = Date()
    }
    
    func numberOfItems() -> Int {
        let numberOfMonth = paging * 2
        
        var monthComponent = calendar.dateComponents([.year,.month], from: self.date)
        monthComponent.month = monthComponent.month! - numberOfMonth
        monthComponent.day = 1
        let firstDay = calendar.date(from: monthComponent)!
        
        let days = calendar.dateComponents([.day], from: firstDay, to: self.lastDateOfMonth()).day! + 1
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let firstGap = firstWeekday - 1
        
        let lastWeekday = calendar.component(.weekday, from: lastDateOfMonth())
        let lastGap = 7 - lastWeekday
        
        number = days + firstGap + lastGap
        return number
    }
    
    private func lastDateOfMonth() -> Date {
        
        var components = calendar.dateComponents([.month, .day, .year], from: date)
        components.month = components.month! + 1
        components.day = 1
        let nextMonthFirst = calendar.date(from: components)!
        var lastDateComponents = calendar.dateComponents([.day], from: nextMonthFirst)
        lastDateComponents.day = -1
        let lastDateMonth = calendar.date(byAdding: lastDateComponents, to: nextMonthFirst)
        return lastDateMonth!
    }
    
    private func lastDateForDisplay() -> Date {
        
        let lastDay = self.lastDateOfMonth()
        
        let lastWeekDay = calendar.component(.weekday, from: lastDay)
        let lastGap = 7 - lastWeekDay
        
        var components = DateComponents()
        components.day = lastGap
        return calendar.date(byAdding: components, to: lastDay)!
        
    }
    
    func dateForCellAtIndexPathWeeks(row: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = row + 1 - self.number
        let date = calendar.date(byAdding: dateComponents, to: self.lastDateForDisplay())
        return date!
    }
    
    func conversionDateFormat(row: Int) -> String {
        let cellDate = dateForCellAtIndexPathWeeks(row: row)
        return dayDateFormatter.string(from: cellDate)
    }
    
    //年月を返す
    func ymTag(row: Int) -> String {
        let cellDate = dateForCellAtIndexPathWeeks(row: row)
        return ymDateFormatter.string(from: cellDate)
    }
    
    //年を返す
    func yearTag(row: Int) -> String {
        let cellDate = dateForCellAtIndexPathWeeks(row: row)
        return yDateFormatter.string(from: cellDate)
    }
    
    //月を返す
    func monthTag(row: Int) -> String {
        let cellDate = dateForCellAtIndexPathWeeks(row: row)
        return mDateFormatter.string(from: cellDate)
    }
    
}

