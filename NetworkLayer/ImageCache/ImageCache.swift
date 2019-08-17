//
//  ImageCacheRequest.swift
//  NetworkLayer
//
//  Created by Adriana Elizondo on 2019/7/27.
//  Copyright © 2019 EF. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    func setImage(from url: URL, with placheHolder: UIImage? = nil) {
        if placheHolder != nil { image = placheHolder }
        Downloader.sharedInstance.downloadImage(from: url) { (downloaded, _) in
            if let result = downloaded {self.image = result}
        }
    }
}
