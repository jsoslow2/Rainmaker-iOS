//
//  UserSearchTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/10/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit


protocol UserSearchTableViewCellDelegate : class {
    func goToProfile(on cell: UserSearchTableViewCell)
}

class UserSearchTableViewCell : UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    var uid : String?
    
    var delegate: UserSearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UserSearchTableViewCell.goToProfile(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func goToProfile(sender: UITapGestureRecognizer) {
        delegate?.goToProfile(on: self)
    }
}
