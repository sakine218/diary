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
    dynamic var subjectText: String = ""
    dynamic var tapNum: Int = 0
    
    static func findAll() -> [Attendance] {
        let realm = RealmFactory.sharedInstance.realm()
        let attendance = realm.objects(Attendance.self)
        return attendance.map { $0 }
    }
}
