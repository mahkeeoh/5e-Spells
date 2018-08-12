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
        return #colorLiteral(red: 0.06104172021, green: 0.1214981899, blue: 0.06018062681, alpha: 1)
    }
    
    static let barColor = newBarColor()
    static let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    static let buttonColor = #colorLiteral(red: 0.3765217662, green: 0.7839545608, blue: 0.3809149861, alpha: 1)
}
