//
//  MemeModel.swift
//  MemeME
//
//  Created by Solomon Dove on 1/26/22.
//

import Foundation
import UIKit

class Meme: NSObject {
    
    var top: String
    var bottom: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.top = topText
        self.bottom = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
