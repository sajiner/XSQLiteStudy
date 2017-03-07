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
//        let result = sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
        return execSQL(sql: sql)
        
    }
    
    func dropTable() -> Bool {
        // 删除sqlite语句
        let sql = "drop table if exists s_stu"
        // 执行sqlite语句
        return execSQL(sql: sql)
    }
    
    func insertTable(columnNameArray: [String], valueArray: [Any]) -> Bool {
        let columnNames = (columnNameArray as NSArray).componentsJoined(by: ",")
        let values = (valueArray as NSArray).componentsJoined(by: "\',\'")
        let sql = "insert into t_stu(\(columnNames)) values (\'\(values)\')"
        return execSQL(sql: sql)
    }
    
    func insertTable(name: String, age: Int, score: Double) -> Bool {
        let sql = "insert into t_stu(name, age, score) values (\'\(name)\', \'\(age)\', \'\(score)\')"
         return execSQL(sql: sql)
    }
    
    func insertBind(columnNameArray: [String], valueArray: [Any]) -> Bool {
        // 1.创建准备语句
        /*
         创建一个“准备语句”，编译好的sql 字符串
         参数一：一个已经打开的数据库对象
         参数二：需要编译的sql 字符串
         参数三：取出sql 字符串的长度 -1 代表自动计算
         参数四：“准备语句”，后期操作的对象
         参数五：通过参数3 取出参数2 剩余的长度的字符串
         */
        let sql = "insert into t_stu(name, age, score) values (?, ?, ?)"
        /// 用来存储，已经编译号的准备语句
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("准备语句创建失败")
            sqlite3_finalize(stmt)
            return false
        }
        
        // 2.绑定参数（不是必须）
        
        /*
         绑定一个字符串到准备语句里
         参数一：准备语句
         参数二：绑定值的索引，从 1 开始
         参数三：需要绑定的值
         参数四：取出参数3 的多少长度 -1 自动计算
         参数五：代表参数的处理方式
         #define SQLITE_STATIC    函数内部处理：参数是一个敞亮，不会被释放，所以就不会额外的再次引用该参数
         #define SQLITE_TRANSIENT 函数内部处理：参数是一个临时的变量，后期有可能被修改或释放，所以函数内部会对参数做一次引用处理，一旦使用完毕，内部会释放
         */
        // 不安全的按位转换
        // 使用这个函数的前提：必须明确知道，值真正的数据类型
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        for obj in valueArray {
            switch obj {
            case is String:
                sqlite3_bind_text(stmt, 1, obj as! String, -1, SQLITE_TRANSIENT)
            case is Int:
                sqlite3_bind_int(stmt, 2, Int32(obj as! Int))
            case is Double:
                sqlite3_bind_double(stmt, 3, obj as! Double)
            default:
                break
            }
        }
        // 3.执行准备语句
        if sqlite3_step(stmt) == SQLITE_DONE {
            //            print("执行成功")
        }
        // 4.重置语句
        sqlite3_reset(stmt)
        // 5.销毁对象
        sqlite3_finalize(stmt)
        
        return true
    }
}

//MARK: - 事物相关
extension XSQLiteTool {
    
    /// 开启事务
    func beginTransaction() {
        let sql = "begin transaction"
        if execSQL(sql: sql) {
            print("开启事务成功")
        } else {
            print("开始事务失败")
        }
    }
    
    /// 结束事务
    func commitTransaction() {
        let sql = "commit transaction"
        if execSQL(sql: sql) {
            print("结束事务成功")
        } else {
            print("结束事务失败")
        }
    }
    
    /// 回滚事务
    func rollBackTransaction() {
        let sql = "rollback transaction"
        if execSQL(sql: sql) {
            print("回滚事务成功")
        } else {
            print("回滚事务失败")
        }
    }
}

extension XSQLiteTool {
    fileprivate func execSQL(sql: String) -> Bool {
        return sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK
    }
}


