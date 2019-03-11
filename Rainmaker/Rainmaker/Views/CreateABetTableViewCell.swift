//
//  CreateABetTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/2/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit


protocol CreateABetTableViewCellDelegate : class {
    func goToCompleteCreateABet (on cell: CreateABetTableViewCell)
}



class CreateABetTableViewCell : UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    var uid : String?
    
    var delegate : CreateABetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateABetTableViewCell.goToCompleteCreateABet(sender:)))
        addGestureRecognizer(tapGesture)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    
    @objc func goToCompleteCreateABet(sender: UIGestureRecognizer) {
        delegate?.goToCompleteCreateABet(on: self)
        print("test")
    }
}
