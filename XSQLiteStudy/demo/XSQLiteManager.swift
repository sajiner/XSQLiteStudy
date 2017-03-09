//
//  XSQLiteManager.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XSQLiteManager: NSObject {

    var db: OpaquePointer? = nil
    
    static let instance: XSQLiteManager = XSQLiteManager()
    
    override init() {
        super.init()
        if deal() {
            print("创建表成功")
        }
    }
    
    func deal() -> Bool {
        let sql = "create table if not exists t_user(id integer primary key autoincrement, name text, content text, icon blob)"
        let pathName = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileName = pathName! + "/user.sqlite"
        if sqlite3_open(fileName, &db) != SQLITE_OK {
            print("打开数据库失败")
            return false
        }
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
    
    func deleteUser(user: XUser) {
        let sql = "delete from t_user where name = '\(user.name)'"
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            print("删除数据失败")
        } else {
            print("删除数据成功")
        }
    }
    
    //MARK: - 存储数据
    func saveUser(users: [XUser]) {
        for user in users {
            let sql = "insert into t_user(name, content, icon) values ('\(user.name)', '\(user.content)', ?)"
            
            var stmt: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
                print("保存数据失败")
            }
            let data = UIImagePNGRepresentation(user.icon!)!
            let bytes = (data as NSData).bytes
            let length = (data as NSData).length
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            sqlite3_bind_blob(stmt, 3, bytes, Int32(length), SQLITE_TRANSIENT)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                print("绑定数据失败")
                continue
            }
            sqlite3_finalize(stmt)
        }
    }
    
    //MARK: - 获取数据
    func getUser() -> [XUser] {
        
        let sql = "select * from t_user"
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("准备语句创建失败")
            return [XUser]()
        }
        
        var users = [XUser]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let count = sqlite3_column_count(stmt)
            
            let user: XUser = XUser()
            users.append(user)
            
            for i in 0..<count {
                
                /// 获取列的名称
                let columnName = sqlite3_column_name(stmt, i)
                let columnNameStr = String(cString: columnName!)
                
                /// 获取列的类型
                let type = sqlite3_column_type(stmt, i)
                /// 根据不同类型，使用不能函数，获取不同值
                var value: Any?
                
                switch type {
                case SQLITE_INTEGER:
                    value = sqlite3_column_int(stmt, i)
                case SQLITE_FLOAT:
                    value = sqlite3_column_double(stmt, i)
                case SQLITE_TEXT:
                    let valueC = sqlite3_column_text(stmt, i)
                    value = String(cString: valueC!)
                case SQLITE_BLOB:
                    let dataByte = sqlite3_column_blob(stmt, i)
                    let dataLength = sqlite3_column_bytes(stmt, i)
                    let data = Data(bytes: dataByte!, count: Int(dataLength))
                    value = UIImage(data: data)
                default:
                    break
                }
                
                switch columnNameStr {
                case "name":
                    user.name = value as! String
                case "content":
                    user.content = value as! String
                case "icon":
                    user.icon = value as? UIImage
                default:
                    break
                }
                
            }
        }
        return users
        
    }
    
}
