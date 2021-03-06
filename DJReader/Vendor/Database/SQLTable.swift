//
//  SQLTable.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

enum FieldType {
    case int
    case text
    case unknown
    
    var name: String? {
        switch self {
        case .int: return "INTEGER"
        case .text: return "TEXT"
        case .unknown: return nil
        }
    }
    
}

protocol SQLTable {
    
    static var tableName: String { get }
    static var fields: [String] { get }
    static var uniqueKeys: [String] { get }
    static var fieldsTypeMapping: [String: FieldType] { get }
    
    var fieldsValueMapping: [String: Any] { get }
    
    func execute()
        
    static func decode<T: Decodable>(_ hash: [String: Any]) -> T?
    
}

extension SQLTable {
    
    func execute() {
        // TODO
    }
    
    static func decode<T: Decodable>(_ hash: [String: Any]) -> T? {
        return DJDecoder<T>(dict: hash).decode()
    }
    
    static var uniqueKeys: [String] {
        return []
    }
    
    static var tableSql: String {
        var rs = ["id INTEGER PRIMARY KEY AUTOINCREMENT not null"]
        
        for field in Self.fields {
            guard let typ = Self.fieldsTypeMapping[field], let name = typ.name else {
                continue
            }
            rs.append("\(field) \(name)")
        }
        
        for uk in uniqueKeys {
            rs.append("UNIQUE(\(uk))")
        }
        
        return "CREATE TABLE IF NOT EXISTS \(Self.tableName)(\(rs.joined(separator: ",")))"
    }
    
    var fieldsValueMapping: [String: Any] {
        return [:]
    }
    
    static var insertSql: String {
        return "insert into \(tableName)(\(fields.joined(separator: ","))) values(\(fields.compactMap { _ in  "?" }.joined(separator: ",")));"
    }
    
    static func createTable() {
        store.createTable(tableSql)
    }
    
    @discardableResult
    func execute(_ operation: SqlOperation, sql: String) -> Any? {
        switch operation {
        case .insert: return store.execute(operation, sql: sql, model: self)
        case .select: return store.execute(operation, sql: sql, model: self, type: Self.self)
        default: break
        }
        return nil
    }
    
    func insert() {
        execute(.insert, sql: Self.insertSql)
    }
    
    func select() -> [[String: Any]] {
        let sql = "select * from \(Self.tableName)"
        guard let rs = execute(.select, sql: sql) as? [[String: Any]] else {
            return []
        }
        return rs
    }
    
    static func selectAll() -> [[String: Any]] {
        let sql = "select * from \(Self.tableName)"
        let rs = store.execute(.select, sql: sql, type: Self.self) as? [[String: Any]] ?? []
        return rs
    }
    
    static func deleteTable() {
        let sql = "drop table \(tableName)"
        store.execute(.delete, sql: sql, type: Self.self)
    }
    
}
