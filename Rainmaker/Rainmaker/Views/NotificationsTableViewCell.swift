//
//  NotificationsTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/18/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

protocol NotificationsTableViewCellDelegate : class {
    func goToBet(on cell: NotificationsTableViewCell)
    func goToProfile(on cell: NotificationsTableViewCell)
}

class NotificationsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var isBet : Int = 0
    var isFollower : Int = 0
    var betKey : String?
    var otherUID : String?
    
    var delegate : NotificationsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NotificationsTableViewCell.goToBet(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func expandButtonPressed(_ sender: Any) {
        delegate?.goToBet(on: self)
    }
    
    @objc func goToBet(sender: UITapGestureRecognizer) {
        if self.isBet == 1 {
            delegate?.goToBet(on: self)
        } else if self.isFollower == 1 {
            delegate?.goToProfile(on: self)
        }

    }
    
}
