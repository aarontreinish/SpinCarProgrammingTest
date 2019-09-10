//
//  ImagesExtension.swift
//  SpinCarProgrammingTest
//
//  Created by Aaron Treinish on 9/4/19.
//  Copyright © 2019 Treinish. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {

    var imageUrlString: String?

    func loadImageUsingCacheWithUrlString(urlString: String) {

        imageUrlString = urlString

        let url = NSURL(string: urlString)

        // Check cache for image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }

        // Otherwise download images
        URLSession.shared.dataTask(with: url! as URL, completionHandler: {(data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {

                let imageToCache = UIImage(data: data!)

                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }).resume()
    }
}
