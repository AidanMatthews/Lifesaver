//
//  DataHelper.swift
//  Lifesaver
//
//  Created by Grant McSheffrey on 2016-10-24.
//  Copyright © 2016 Grant McSheffrey. All rights reserved.
//

import UIKit
import Darwin

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

    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let dbPath = "lifesaver.db"
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
        } else {
            print("Unable to open database.")
        }
        return db
    }
    
    func createTables() {
        let userColumnsString = "Id INT PRIMARY KEY NOT NULL, Name CHAR(255)"
        createTable(tableName: "User", tableColumnsString: userColumnsString)
        
        let requestColumnsString = "Id INT PRIMARY KEY NOT NULL, User INT FOREIGN KEY, NotifyRadius INT, Call911 BOOL, EmergencyReason INT, OtherInfo CHAR(1024), Timestamp DOUBLE, Latitude FLOAT, Longitude FLOAT"
        createTable(tableName: "Request", tableColumnsString: requestColumnsString)
    }

    func createTable(tableName: String, tableColumnsString: String) {
        let createTableString = "CREATE TABLE IF NOT EXISTS \(tableName)(\(tableColumnsString));"
        var createTableStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\(tableName) table created.")
            } else {
                print("\(tableName) table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }

        sqlite3_finalize(createTableStatement)
    }
    
    func addRequest(userId: Int32, notifyRadius: Int32, call911: Bool, emergencyReason: Int32, otherInfo: String) {
        let id = arc4random_uniform(1024 * 1024)
        let timestamp: NSDate = NSDate()
        let latitude = 45.5
        let longitude = 68.2
        
        let insertStatementString = "INSERT INTO Request (Id, User, NotifyRadius, Call911, EmergencyReason, OtherInfo, Timestamp, Latitude, Longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
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
}
