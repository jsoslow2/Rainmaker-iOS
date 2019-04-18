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
    var notifications : [Notification]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self
        
        NotificationService.loadNotifications(currentUID: Constants.currentUID) { (notifications) in
            self.notifications = notifications
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notifications = notifications {
            return notifications.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell")! as! NotificationsTableViewCell
        
        let notification = notifications![indexPath.row]
        
        cell.notificationLabel.attributedText = notification.notificationLabel
        cell.expandButton.setImage(notification.image, for: .normal)
        
        return cell
    }
}
