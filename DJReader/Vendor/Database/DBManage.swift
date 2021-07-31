//
//  DBManage.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation
import SQLite3

class Person
{
    
    var name: String = ""
    var age: Int = 0
    var id: Int = 0
    
    init(id:Int, name:String, age:Int)
    {
        self.id = id
        self.name = name
        self.age = age
    }
    
}

enum SqlOperation {
    case insert(String)
    case select(String)
    case update(String)
    case delete(String)
    case createTable(String)
}

let store = DBManager()

class DBManager {
    
    let dbPath = "reader_test.sqlite"
    
    var db: OpaquePointer?
    
    init() {
        
    }
    
    func execute(_ operation: SqlOperation) {
        self.db = openDatabase()
        
        switch operation {
        case .insert(let sql): insert(sql)
        case .select(let sql): read(sql)
        case .createTable(let sql): createTable(sql)
        default: break
        }
        
        self.closeDatabase(db)
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)

        guard sqlite3_open(fileURL.path, &db) == SQLITE_OK else {
            sqlite3_close(db)
            print("error open database~")
            return nil
        }
        
        print("Successfully opened connection to database at \(dbPath)")
        return db
    }
    
    func closeDatabase(_ db: OpaquePointer?) {
        sqlite3_close(db)
    }
    
    func createTable(_ sql: String) {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("table created.")
            } else {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(_ sql: String) {
        
    }
    
    func read(_ sql: String) {
        
    }
}

