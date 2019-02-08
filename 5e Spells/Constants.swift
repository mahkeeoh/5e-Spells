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
        return #colorLiteral(red: 0, green: 0.3019607843, blue: 0.2509803922, alpha: 1)
    }
    
    static let barColor = newBarColor()
    static let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    static let buttonColor = #colorLiteral(red: 0.1137254902, green: 0.9137254902, blue: 0.7137254902, alpha: 1)
    static let headerColor = #colorLiteral(red: 0.9211695194, green: 0.9211695194, blue: 0.9211695194, alpha: 1)
    
}
