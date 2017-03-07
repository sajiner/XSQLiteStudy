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
            print("插入表成功")
        } else {
            print("插入表失败")
        }
    }
}
