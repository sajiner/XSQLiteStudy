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
//        let fileName = NSSearchPathForDirectoriesInDomains(.documentationDirectory, .userDomainMask, true).first
        let pathName: String = "/Users/sajiner/Desktop/demomo/sajiner.sqlite"
        let db = FMDatabase(path: pathName)
        return db!
    }()
    
    override init() {
        super.init()
        if !db.open() {
            print("打开数据库失败")
            return
        }
    }
    
    func selectTable() -> Bool {
        let sql = "select age from t_stu where name = 'zx'"
        return db.executeStatements(sql)
    }
}
