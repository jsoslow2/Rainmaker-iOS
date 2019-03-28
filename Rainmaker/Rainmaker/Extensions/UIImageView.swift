//
//  UIImageView.swift
//  Rainmaker
//
//  Created by Jack Soslow on 3/27/19.
//  Copyright © 2019 Jack Soslow. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func getImage (url: URL) {
        //check to see if image is in cache
        if let image = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = image
        }
        
            let session = URLSession.shared
            
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error)
                } else {
                    
                    DispatchQueue.main.async {
                        
                        if let downloadedImage = UIImage(data: data!) {
                            imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    
}
