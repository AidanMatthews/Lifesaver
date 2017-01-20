//
//  DataHelper.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-10-24.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import Darwin
import CoreLocation

class DataHelper: NSObject {
    static let sharedInstance = DataHelper()

    var db: OpaquePointer?

    override init() {
        super.init()

        self.db = openDatabase()
        createTables()
        createTestUsers()
    }
    
    func createTestUsers() {
        createUser(id: 1, name: "Aidan Matthews")
        createUser(id: 2, name: "Stevie B")
    }

    func createUser(id: Int32, name: String) {
        let insertStatementString = "INSERT INTO User (Id, Name) VALUES (?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, name.cString(using: String.Encoding.utf8), -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted user.")
            } else {
                print("Could not insert user.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }

        sqlite3_finalize(insertStatement)
    }

    func databasePath() -> String? {
        let paths: [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir: String = paths.last!
        let dbUrl = NSURL(fileURLWithPath: documentsDir).appendingPathComponent("lifesaver.db")
        return dbUrl?.absoluteString
    }

    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let dbPath = databasePath()!
        if sqlite3_open((dbPath as NSString).utf8String, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
        } else {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("Unable to open database at \(dbPath): \(errMsg)")
            sqlite3_close(db)
        }
        return db
    }
    
    func createTables() {
        let userColumnsString = "Id INTEGER PRIMARY KEY NOT NULL, Name TEXT"
        createTable(tableName: "User", tableColumnsString: userColumnsString)
        
        let requestColumnsString = "Id INTEGER PRIMARY KEY NOT NULL, UserId INTEGER, NotifyRadius INTEGER, Call911 BOOL, EmergencyReason INTEGER, OtherInfo TEXT, Timestamp DOUBLE, Latitude FLOAT, Longitude FLOAT, FOREIGN KEY(UserId) REFERENCES User(Id)"
        createTable(tableName: "Request", tableColumnsString: requestColumnsString)
    }

    func createTable(tableName: String, tableColumnsString: String) {
        let createTableString = "CREATE TABLE \(tableName)(\(tableColumnsString));"
        print("Creating table with string: \(createTableString)")
        var createTableStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\(tableName) table created.")
            } else {
                print("\(tableName) table could not be created.")
            }
        } else {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("CREATE TABLE statement could not be prepared: \(errMsg)")
        }

        sqlite3_finalize(createTableStatement)
    }
    
    func addRequest(userId: Int32, notifyRadius: Int32, call911: Bool, emergencyReason: Int32, otherInfo: String) {
        let id = arc4random_uniform(1024 * 1024)
        let timestamp: NSDate = NSDate()
        let latitude = 45.5
        let longitude = 68.2
        
        let insertStatementString = "INSERT INTO Request (Id, UserId, NotifyRadius, Call911, EmergencyReason, OtherInfo, Timestamp, Latitude, Longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_int(insertStatement, 2, userId)
            sqlite3_bind_int(insertStatement, 3, notifyRadius)
            sqlite3_bind_int(insertStatement, 4, call911 ? 1 : 0)
            sqlite3_bind_int(insertStatement, 5, emergencyReason)
            sqlite3_bind_text(insertStatement, 6, otherInfo.cString(using: String.Encoding.utf8), -1, nil)
            sqlite3_bind_double(insertStatement, 7, timestamp.timeIntervalSince1970)
            sqlite3_bind_double(insertStatement, 8, latitude)
            sqlite3_bind_double(insertStatement, 9, longitude)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted request.")
            } else {
                print("Could not insert request.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(insertStatement)
    }
    
    func getLocalHelpRequests(currentLocation: CLLocationCoordinate2D) -> [HelpRequest] {
        var localRequests: [HelpRequest]
        let selectRequestsString = "SELECT * FROM Request;"
        print("Getting local help requests with string: \(selectRequestsString)")
        var selectRequestsStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, selectRequestsString, -1, &selectRequestsStatement, nil) == SQLITE_OK {
            if sqlite3_step(selectRequestsStatement) == SQLITE_ROW {
                let notifyRadius = sqlite3_column_int(selectRequestsStatement, 0)
                let call911 = sqlite3_column_int(selectRequestsStatement, 1)
                let emergencyReason = sqlite3_column_int(selectRequestsStatement, 2)
                let infoQueryResult = sqlite3_column_text(selectRequestsStatement, 3)
                let additionalInfo = String.init(cString: infoQueryResult!)
                let latitude = sqlite3_column_int(selectRequestsStatement, 4)
                let longitude = sqlite3_column_int(selectRequestsStatement, 5)
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                let localRequest = HelpRequest(notifyRadius: Int(notifyRadius),
                                               call911: (call911 == 0),
                                               emergencyReason: Int(emergencyReason),
                                               additionalInfo: additionalInfo,
                                               coordinate: coordinate)
                localRequests.append(localRequest)
            } else {
                print("No local requests found.")
            }
        } else {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("SELECT * FROM REQUEST statement could not be prepared: \(errMsg)")
        }
        
        sqlite3_finalize(selectRequestsStatement)
    }
}
