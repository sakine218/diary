//
//  Summery.swift
//  heal
//
//  Created by 西林咲音 on 2017/09/19.
//  Copyright © 2017年 西林咲音. All rights reserved.
//

import UIKit
import RealmSwift

class Summery: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    var contents: List<Content> = List<Content>()
    
    override static func primaryKey() -> String{
        return "id"
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    static func lastId() -> Int {
        let realm = try! Realm()
        if let todo = realm.objects(Summery.self).sorted(byKeyPath: "id", ascending: false).first {
            return todo.id + 1
        }else {
            return 1
        }
    }
    
    static func findAll() -> [Summery] {
        let realm = RealmFactory.sharedInstance.realm()
        let summeries = realm.objects(Summery.self)
        return summeries.map { $0 }
    }
    
    static func findAllWithSort() -> [Summery] {
        let realm = RealmFactory.sharedInstance.realm()
        let summeries = realm.objects(Summery.self).sorted(byKeyPath: "title", ascending: false)
        return summeries.map { $0 }
    }
    
    static func find(withId title: String) -> [Summery] {
        let realm = RealmFactory.sharedInstance.realm()
        let summeries = realm.objects(Summery.self).filter("title == %@",title)
        return summeries.map { $0 }
    }
    
    static func deleteAll() {
        let realm = RealmFactory.sharedInstance.realm()
        do {
            try realm.write {
                realm.delete(realm.objects(Summery.self))
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func delete() {
        let realm = RealmFactory.sharedInstance.realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func save()  {
        let realm = RealmFactory.sharedInstance.realm()
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
}
