//
//  XFMDBTool.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/7.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XFMDBTool: NSObject {

    static let shareInstance: XFMDBTool = XFMDBTool()
    
    var db: FMDatabase = {
        let fileName = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let pathName: String = fileName! + "/zx.sqlite"
//        let pathName: String = "/Users/sajiner/Desktop/demomo/sajiner.sqlite"
        // 如果传入的参数是“”空串，fmdb会在临时文件目录下创建这个数据库，如果传入的参数是NULL，会建立一个内存中的数据库
        let db = FMDatabase(path: pathName)
        return db!
    }()
    
    var queue: FMDatabaseQueue = {
        let fileName = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let pathName: String = fileName! + "/zx.sqlite"
        let queue = FMDatabaseQueue(path: pathName)
        return queue!
    }()
    
    override init() {
        super.init()
    
        if !db.open() {
            print("打开数据库失败")
            return
        }
        guard createTable() else {
            print("创建表失败")
            return
        }
        print("创建表成功")
    }
    
    func query() {
        let sql = "select name, age from t_person"
        let resultSet = db.executeQuery(sql, withArgumentsIn: nil)
        guard let set = resultSet else {
            return
        }
        while set.next() {
            let name = set.string(forColumn: "name")
            let age = set.int(forColumn: "age")
            print(name ?? "", age)
        }
    }
    
    func insertTable() -> Bool {
        let sql = "insert into t_person(name, age) values ('zx', 18)"
        return db.executeUpdate(sql, withArgumentsIn: nil)
    }
    
    func createTable() -> Bool {
        let sql = "create table if not exists t_person(id integer primary key autoincrement, name text, age integer)"
        return db.executeStatements(sql, withResultBlock: nil)
    }
}
