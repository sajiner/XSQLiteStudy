//
//  ViewController.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/7.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        XSQLiteTool.shareInstance.beginTransaction()
        let result1 = XStudent.updateStudent(setStr: "score = score - 10", condition: "name = 'sajiner'")
        let result2 = XStudent.updateStudent(setStr: "score = score + 10", condition: "name     `= 'zx'")
        
        if result1 && result2 {
            XSQLiteTool.shareInstance.commitTransaction()
        } else {
            XSQLiteTool.shareInstance.rollBackTransaction()
        }
//        let stu = XStudent(name: "sajiner", age: 29, score: 89)
//        
//        
//        print("开始插入")
//        let beginTime = CFAbsoluteTimeGetCurrent()
//        XSQLiteTool.shareInstance.beginTransaction()
////        for _ in 0..<10000 {
////            stu.insertStudent()
////        }
//        stu.insertBindStu()
//        XSQLiteTool.shareInstance.commitTransaction()
//        let endTime = CFAbsoluteTimeGetCurrent()
//        
//        print(endTime - beginTime)
//        print("结束插入")
    }
}
