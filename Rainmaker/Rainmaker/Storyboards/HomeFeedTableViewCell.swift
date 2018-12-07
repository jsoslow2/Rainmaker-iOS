//
//  HomeFeedTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var betTitle: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftButton.layer.cornerRadius = 10
        rightButton.layer.cornerRadius = 10
        
        //circular profile photo
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
