//
//  XUser.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XUser: NSObject {

    var name: String = ""
    var content: String = ""
    var icon: UIImage?
    
   override init() {
        super.init()
    }
    
    init(name: String, content: String, icon: UIImage) {
        self.name = name
        self.content = content
        self.icon = icon
    }
}
