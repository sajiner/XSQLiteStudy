//
//  XDataTool.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XDataTool: NSObject {

   static func getData(result: (_ users: [XUser])->()) {
        /// 从本地获取数据
        let datas = XSQLiteManager.instance.getUser()
        if datas.count != 0 {
            /// 直接展示
            result(datas)
            return
        }
        /// 从网络获取数据
        let user1 = XUser(name: "sjainer", content: "谁是🐷谁不减肥谁不是猪", icon: UIImage(named: "smile")!)
        let user2 = XUser(name: "lili", content: "你是谁你啊摇的 u 发挥染发染发", icon: UIImage(named: "smile")!)
        let user3 = XUser(name: "jock", content: "学习是一件不能记得来的事儿", icon: UIImage(named: "smile")!)
        let userArr = [user1, user2, user3]
        /// 保存到本地
        XSQLiteManager.instance.saveUser(users: userArr)
        /// 传值展示
        result(userArr)
        
    }
}
