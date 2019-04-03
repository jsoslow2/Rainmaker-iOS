//
//  HomeFeedTableViewCell.swift
//  Rainmaker
//
//  Created by Jack Soslow on 25/11/2018.
//  Copyright © 2018 Jack Soslow. All rights reserved.
//

import UIKit

protocol HomeFeedTableViewCellDelegate : class {
    func didTapBetButton(which button: Int, on cell: HomeFeedTableViewCell)
    func goToProfile(on cell: HomeFeedTableViewCell)
}

class HomeFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "default copy")
        return imageView
    }()
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var betTitle: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var betKey: String?
    var userID: String?
    
    var delegate: HomeFeedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftButton.layer.cornerRadius = 10
        rightButton.layer.cornerRadius = 10
        leftButton.addShadowView()
        rightButton.addShadowView()
        
        //circular profile photo
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeFeedTableViewCell.goToProfile(sender:)))
        addGestureRecognizer(tapGesture)
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func goToProfile(sender: UITapGestureRecognizer) {
        delegate?.goToProfile(on: self)
    }
    

    @IBAction func firstBetButtonTapped(_ sender: UIButton) {
        delegate!.didTapBetButton(which: 0, on: self)
       
    }
    
    
    @IBAction func secondBetButtonTapped(_ sender: UIButton) {
        delegate!.didTapBetButton(which: 1, on: self)
    }
    
    func getPicture(uid: String, completion: @escaping(UIImage) -> Void) {
        UserService.getImageURL(userUID: uid) { (imageURL) in
            let url = URL(string: imageURL)
            let session = URLSession.shared
            
            session.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    
                    DispatchQueue.main.async {
                        let theImage = UIImage(data: data!)
                        
                        self.profilePicture.image = theImage
                        completion(theImage!)
                    }
                }
            }).resume()
        }
    }
    
}
