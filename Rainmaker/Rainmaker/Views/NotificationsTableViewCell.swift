//
//  NotificationsTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/18/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class NotificationsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var isBet : Int = 0
    var isFollower : Int = 0
    var betKey : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func expandButtonPressed(_ sender: Any) {
    }
    
}
