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
    
    
}
