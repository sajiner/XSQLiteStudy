//
//  XStudent.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/7.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XStudent: NSObject {

    var name: String = ""
    var age: Int = 0
    var score: Double = 0
    
    init(name: String, age: Int, score: Double) {
        self.name = name
        self.age = age
        self.score = score
    }
    
    func insertStudent() {
//        let result = XSQLiteTool.shareInstance.insertTable(name: self.name, age: self.age, score: self.score)
        let result = XSQLiteTool.shareInstance.insertTable(columnNameArray: ["name", "age", "score"], valueArray: [self.name, self.age, self.score])
        if result {
//            print("插入表成功")
        } else {
            print("插入表失败")
        }
    }
}

extension XStudent {
    func insertBind() {
        
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
        let db = XSQLiteTool.shareInstance.db
        /// 用来存储，已经编译号的准备语句
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("准备语句创建失败")
            return
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
        sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
        sqlite3_bind_int(stmt, 2, Int32(age))
        sqlite3_bind_double(stmt, 3, score)
        // 3.执行准备语句
        if sqlite3_step(stmt) == SQLITE_DONE {
//            print("执行成功")
        }
        // 4.重置语句
        sqlite3_reset(stmt)
        // 5.销毁对象
        sqlite3_finalize(stmt)
    }
    
    func insertBind10000() {
        // 1.创建准备语句
        let sql = "insert into t_stu(name, age, score) values (?, ?, ?)"
        let db = XSQLiteTool.shareInstance.db
        /// 用来存储，已经编译号的准备语句
        var stmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            print("准备语句创建失败")
            return
        }
       
        for _ in 0..<10000 {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(stmt, 2, Int32(age))
            sqlite3_bind_double(stmt, 3, score)
            // 3.执行准备语句
            if sqlite3_step(stmt) == SQLITE_DONE {
                //            print("执行成功")
            }
            // 4.重置语句
            sqlite3_reset(stmt)
        }
        // 5.销毁对象
        sqlite3_finalize(stmt)
    }
}
