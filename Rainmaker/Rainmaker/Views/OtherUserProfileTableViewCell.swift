//
//  OtherUserProfileTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 2/28/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

class OtherUserProfileTableViewCell : UITableViewCell {
    
    @IBOutlet weak var winLoss: UILabel!
    @IBOutlet weak var betQuestion: UILabel!
    @IBOutlet weak var typeOfGame: UILabel!
    @IBOutlet weak var betAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
