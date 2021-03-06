import RealmSwift

class Content: Object {
    
    dynamic var date: String = ""
    dynamic var note = ""
    dynamic var redValue: Float = Float()
    dynamic var greenValue: Float = Float()
    dynamic var blueValue: Float = Float()
    dynamic var value: Float = Float()
    dynamic var isSum: Bool = false
    var attendanceArray = List<Attendance>()
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
    convenience init(date: String, note: String, redValue: Float, greenValue: Float, blueValue: Float, value: Float, attendanceArray: [[String: Any]], tapArray: [Int]) {
        self.init()
        self.date = date
        self.note = note
        self.redValue = redValue
        self.greenValue = greenValue
        self.blueValue = blueValue
        self.value = value
        
        for (index, item) in attendanceArray.enumerated() {
            let attendance: Attendance = Attendance()
            attendance.id = Attendance.lastId() + index
            attendance.subjectText = item["subject"] as! String
            attendance.tapNum = tapArray[index]
            self.attendanceArray.append(attendance)
        }
    }
    
    static func findAll() -> [Content] {
        let realm = RealmFactory.sharedInstance.realm()
        let contents = realm.objects(Content.self)
        return contents.map { $0 }
    }
    
    static func findAllWithSort() -> [Content] {
        let realm = RealmFactory.sharedInstance.realm()
        let contents = realm.objects(Content.self).sorted(byKeyPath: "date", ascending: false)
        return contents.map { $0 }
    }
    
    static func find(withId date: String) -> [Content] {
        let realm = RealmFactory.sharedInstance.realm()
        let contents = realm.objects(Content.self).filter("date == %@",date)
        return contents.map { $0 }
    }
    
    static func deleteAll() {
        let realm = RealmFactory.sharedInstance.realm()
        do {
            try realm.write {
                realm.delete(realm.objects(Content.self))
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    static func delete(withId date: String) {
        let realm = RealmFactory.sharedInstance.realm()
        do {
            try realm.write {
                realm.delete(realm.objects(Content.self).filter("date == %@", date))
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func delete() {
        let realm = RealmFactory.sharedInstance.realm()
        try! realm.write {
            realm.delete(self.attendanceArray)
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
