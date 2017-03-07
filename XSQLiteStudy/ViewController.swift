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
        let tool = XSQLiteTool.shareInstance
        print(tool)
    }
}
