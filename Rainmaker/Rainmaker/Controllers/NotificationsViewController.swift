//
//  NotificationsViewController.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/16/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class NotificationsViewController : UIViewController, UITableViewDataSource, NotificationsTableViewCellDelegate {

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
        cell.delegate = self
        
        let notification = notifications![indexPath.row]
        
        cell.notificationLabel.attributedText = notification.notificationLabel
        cell.expandButton.setImage(notification.image, for: .normal)
        cell.betKey = notification.betKey
        cell.isBet = notification.isBet
        cell.isFollower = notification.isFollow
        cell.otherUID = notification.otherUID
        
        return cell
    }
    
    func goToBet(on cell: NotificationsTableViewCell) {
        let mainStoryboard = UIStoryboard(name: "Bet", bundle: nil)
        
        guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "betViewController") as? BetViewController else {
            print("no vC found"); return}
        
        destinationVC.transferText = cell.betKey
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func goToProfile(on cell: NotificationsTableViewCell) {
        let mainStoryboard = UIStoryboard(name: "HomeScreen", bundle: nil)
        
        guard let destinationVC = mainStoryboard.instantiateViewController(withIdentifier: "otherUserProfile") as? OtherUserProfileViewController else {
            print("no VC found"); return}
        
        destinationVC.transferText = cell.otherUID!
        
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
}
