import RealmSwift

class RealmFactory {
    
    static let sharedInstance = RealmFactory()
    internal var configuration: Realm.Configuration?
    
    private init() {
    }
    
    internal func realm() -> Realm {
        //if let configuration = configuration {
        //return try! Realm(configuration: configuration)
        //} else {
        return try! Realm()
        //}
    }
    
    internal func migration() {
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
}
