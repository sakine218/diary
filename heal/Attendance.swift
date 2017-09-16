//
//  Attendance.swift
//  heal
//
//  Created by 西林咲音 on 2017/08/24.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit
import RealmSwift

class Attendance: Object {
    dynamic var id: Int = 0
    dynamic var subjectText: String = ""
    dynamic var tapNum: Int = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    static func lastId() -> Int {
        let realm = try! Realm()
        if let attendance = realm.objects(Attendance.self).sorted(byKeyPath: "id", ascending: false).first {
            return attendance.id + 1
        } else {
            return 1
        }
    }
    
    static func findAll() -> [Attendance] {
        let realm = RealmFactory.sharedInstance.realm()
        let attendance = realm.objects(Attendance.self)
        return attendance.map { $0 }
    }
}
