//
//  Constants.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 8/2/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static func newBarColor() -> UIColor {
        return #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.231372549, alpha: 1)
    }
    
    static let barColor = newBarColor()
    static let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    static let buttonColor = #colorLiteral(red: 0.7019607843, green: 0.7764705882, blue: 0.337254902, alpha: 1)
}
