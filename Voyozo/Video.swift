//
//  Video.swift
//  Voyozo
//
//  Created by rex on 2017. 10. 29..
//  Copyright © 2017년 ijuyong. All rights reserved.
//

import Foundation
import UIKit

class Video {
    var title: String?
    var thumbImage: UIImage?
    var thumbImageURL: String?
    var mainImageURL: String?
    var descr: String?
    var playURL: String?
    
    init(title: String?,
         thumbImage: String?,
         thumbImageURL: String?,
         mainImageURL: String?,
         descr: String?,
         playURL: String?){
        self.title = title
        self.thumbImage = nil
        self.thumbImageURL = thumbImageURL
        self.mainImageURL = mainImageURL
        self.descr = descr
        self.playURL = playURL
    }
}
