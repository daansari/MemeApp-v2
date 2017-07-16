//
//  TextFieldExtension.swift
//  MemeApp
//
//  Created by Danish Ahmed Ansari on 7/16/17.
//  Copyright © 2017 DeepTurf. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    class func configure(textfield: UITextField, text: String?, defaultAttributes: [String: Any]?) {
        if let text = text {
            textfield.text = text
        }
        
        if let defaultAttributes = defaultAttributes {
            textfield.defaultTextAttributes = defaultAttributes
        }
        
        textfield.textAlignment = .center
        textfield.borderStyle = .none
    }
}

extension UILabel {
    class func configure(label: UILabel, text: String?, defaultAttributes: [NSAttributedStringKey: Any]?) {
        if let defaultAttributes = defaultAttributes {
            label.attributedText = NSAttributedString(string: text!, attributes: defaultAttributes)
        }
        
        label.textAlignment = .center
    }
}
