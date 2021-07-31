//
//  SQLTable.swift
//  DJReader
//
//  Created by 季勤强 on 2021/7/31.
//

import Foundation

protocol SQLTable {
    
    var tableName: String { get }
    var tableSql: String { get }
    var needId: Bool { get }
    var insertKeys: [String] { get }
    
}

extension SQLTable {
    
    var needId: Bool {
        return true
    }
    
    var tableSql: String {
        return createTableSql(needID: needId)
    }
    
    var fields: [String] {
        return self.childs.compactMap { $0.label }
    }
    
    var insertSql: String {
        var sql = "insert to (id"
        
        let fields = self.childs.compactMap { $0.label }
        sql = sql + fields.joined(separator: ",") + ""
        
        return "insert into \(self.tableName) (id,\(fields.joined(separator: ","))) values(?,\(fields.compactMap { _ in "?" }.joined(separator: ",")));"
    }
    
    var insertKeys: [String] {
        return []
    }
    
    var childs: Mirror.Children {
        let mirror = Mirror(reflecting: self)
        return mirror.children
    }
    
    var selectAllSql: String {
        return "select * from \(tableName)"
    }
    
    func createTableSql(needID: Bool) -> String {
        var fieldsSql: [String] = needID ? ["id INTEGER PRIMARY KEY not null AUTOINCREMENT"] : []
        
        for child in childs {
            guard let name = child.label else { continue }
            let typ = getFieldType(child.value)
            fieldsSql.append("\(name) \(typ) not null default \"\"")
        }
        
        return "CREATE TABLE IF NOT EXISTS \(tableName)(\(fieldsSql.joined(separator: ",")));"
    }
    
    func selectSql(id: Int) -> String {
        return "select (\(fields.joined(separator: ","))) from \(tableName) where id=\(id)"
    }
    
    func createTableSql(_ fields: [String]) -> String {
        var fields = fields
        if needId {
            fields.insert("id INTEGER PRIMARY KEY AUTOINCREMENT not null", at: 0)
        }
        
        return "CREATE TABLE IF NOT EXISTS \(tableName)(\(fields.joined(separator: ",")));"
    }
    
    private func getFieldType(_ value: Any) -> String {
        if let _ = value as? Int {
            return "INTEGER"
        } else if let _ = value as? String {
            return "TEXT"
        }
        
        return "TEXT"
    }
    
}
