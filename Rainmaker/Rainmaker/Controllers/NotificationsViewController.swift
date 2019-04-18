//
//  NotificationsViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/16/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class NotificationsViewController : UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell")! as! NotificationsTableViewCell
        
        return cell
    }
}
