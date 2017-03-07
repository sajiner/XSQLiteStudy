//
//  XSQLiteTool.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/7.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XSQLiteTool: NSObject {

     var db: OpaquePointer? = nil
    
    static let shareInstance = XSQLiteTool()
    
    override init() {
        super.init()
        
        let filePath: String! = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let fileName = filePath + "/demo.sqlite"
        print(filePath)
        /**
         *  sqlite3_open 使用这个函数打开一个数据库
         *  参数一: 需要打开的数据库文件路径
         *  参数二: 一个指向SQlite3数据结构的指针, 到时候操作数据库都需要使用这个对象
         *  功能作用: 如果需要打开数据库文件路径不存在, 就会创建该文件;如果存在, 就直接打开; 可通过返回值, 查看是否打开成功
         */
        if sqlite3_open(fileName, &db) == SQLITE_OK {
//            print("打开数据库成功")
            if createTable() {
                print("创建表成功")
            } else {
                print("创建表失败")
            }
        } else {
            print("打开数据库失败")
        }
    }
    
}

extension XSQLiteTool {
    func createTable() -> Bool {
        // 创建sqlite语句
        let sql = "create table if not exists t_stu(name text, age integer, score real, id integer primary key autoincrement)"
        // 执行SQL语句
        // 参数一: 数据库
        // 参数二: 需要执行的SQL语句
        // 参数三: 回调结果, 执行完毕之后的回调函数, 如果不需要置为NULL
        // 参数四: 参数三的第一个参数, 刻意通过这个传值给回调函数 如果不需要置为NULL
        // 参数五: 错误信息, 通过传递一个地址, 赋值给外界, 如果不需要置为NULL
        let result = sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
        return result
        
    }
    
    func dropTable() -> Bool {
        // 删除sqlite语句
        let sql = "drop table if exists s_stu"
        // 执行sqlite语句
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
    
    func insertTable(columnNameArray: [String], valueArray: [Any]) -> Bool {
        let columnNames = (columnNameArray as NSArray).componentsJoined(by: ",")
        let values = (valueArray as NSArray).componentsJoined(by: "\',\'")
        let sql = "insert into t_stu(\(columnNames)) values (\'\(values)\')"
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
    
    func insertTable(name: String, age: Int, score: Double) -> Bool {
        let sql = "insert into t_stu(name, age, score) values (\'\(name)\', \'\(age)\', \'\(score)\')"
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
}
