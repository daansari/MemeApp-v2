//
//  MemeTableViewCell.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/16/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    func getAttributesForMemeTextLabel() -> [NSAttributedStringKey: Any] {
        let memeTextAttributes:[NSAttributedStringKey:Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!
        ]
        return memeTextAttributes
    }
    
    func getAttributesForTextLabel() -> [NSAttributedStringKey: Any] {
        let memeTextAttributes:[NSAttributedStringKey:Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)!
        ]
        return memeTextAttributes
    }
    
    func setText(label: UILabel, text: String?, memeTextAttributes: [NSAttributedStringKey: Any], textAlignment: NSTextAlignment?) {
        UILabel.configure(label: label, text: text, defaultAttributes: memeTextAttributes)
        label.textAlignment = textAlignment!
    }

}
