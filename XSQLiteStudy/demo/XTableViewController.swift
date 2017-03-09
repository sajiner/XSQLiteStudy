//
//  XTableViewController.swift
//  XSQLiteStudy
//
//  Created by sajiner on 2017/3/9.
//  Copyright © 2017年 sajiner. All rights reserved.
//

import UIKit

class XTableViewController: UITableViewController {

    var dateSource = [XUser]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = "跳转页"
        
        XDataTool.getData { (users: [XUser]) in
            self.dateSource = users
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dateSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let user = dateSource[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.content
        cell.imageView?.image = user.icon
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = dateSource[indexPath.row]
            dateSource.remove(at: indexPath.row)
            XSQLiteManager.instance.deleteUser(user: user)
            tableView.reloadData()
        }
    }
    
}
