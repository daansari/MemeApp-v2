//
//  Meme.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/16/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    static let TopText = "TopText"
    static let BottomText = "BottomText"
    static let OriginalImage = "OriginalImage"
    static let MemedImage = "MemedImage"
    
    init(dictionary: [String : Any]) {
        self.topText = dictionary[Meme.TopText]! as! String
        self.bottomText = dictionary[Meme.BottomText]! as! String
        self.originalImage = dictionary[Meme.OriginalImage]! as! UIImage
        self.memedImage = dictionary[Meme.MemedImage]! as! UIImage
    }
}

class Memes {
    var memesData = [Meme]()
    
//    init(meme: Meme) {
//        memes.append(meme)
//    }
    
    func addMeme(meme: Meme) {
        memesData.append(meme)
    }
    
    func removeMemeAt(index: Int) {
        memesData.remove(at: index)
    }
}
