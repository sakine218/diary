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
    
    private var ymDateFormatter: DateFormatter {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "YM"
        return formatter
    }
    
    init() {
        
        calendar.locale = Locale(identifier: "ja_JP")
    }
    
    
    // 現在の月から指定したpagingの分だけセルの数を返す
    // 引数のpagingが1増えるごとに2月分のセルの数を増やす
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
    
    // 指定された月の最後の日
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
    
    func firstDate() -> Date {
        
        return Date()
    }
    
    
    /*      表記する日にちの取得　週のカレンダー
     引数　row          ->  UICollectionViewのIndexPath.row
     startDate    ->  指定した月　カレンダーを始める月
     return  date      ->  セルに入れる日付                  */
    func dateForCellAtIndexPathWeeks(row: Int) -> Date {
        //始まりの日が週の何番目かを計算(日曜日が１) 指定した月の初日から数える
        var dateComponents = DateComponents()
        dateComponents.day = row + 2 - self.number
        //計算して、基準の日から何日マイナス、加算するか dateComponents.day = -2 とか
        let date = calendar.date(byAdding: dateComponents, to: lastDateOfMonth())
        print("row...\(row), date... \(date ?? Date())")
        return date!
    }
    
    
    
    /*      表記の変更 これをセルを作成する時に呼び出す
     引数  row         -> UICollectionViewのIndexPath.row
     startDate   -> 指定した月　カレンダーを始める月
     return  String   -> セルに入れる日付をString型にしたもの
     */
    func conversionDateFormat(row: Int) -> String {
        let cellDate = dateForCellAtIndexPathWeeks(row: row)
        return dayDateFormatter.string(from: cellDate)
    }
    
    
    //月を返す
    func monthTag(row: Int) -> String {
        let cellDate = dateForCellAtIndexPathWeeks(row: row)
        return ymDateFormatter.string(from: cellDate)
    }
    
}
