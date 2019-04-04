//
//  UIView.swift
//  Rainmaker
//
//  Created by Jack Soslow on 4/3/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadowView(width:CGFloat=0.0, height:CGFloat=1.0, Opacidade:Float=0.5, maskToBounds:Bool=false, radius:CGFloat=1.0){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacidade
        self.layer.masksToBounds = maskToBounds
    }
    
}
