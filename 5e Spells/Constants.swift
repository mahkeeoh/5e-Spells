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
       // return #colorLiteral(red: 0.5254901961, green: 0.4235294118, blue: 0.4823529412, alpha: 1)
        return #colorLiteral(red: 0.6027600169, green: 0.4866663218, blue: 0.5612903833, alpha: 1)
    }
    
    static let barColor = newBarColor()
    static let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    static let buttonColor = #colorLiteral(red: 0.6072270274, green: 0.1531594694, blue: 0.1682837009, alpha: 1)
    static let navButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let headerColor = #colorLiteral(red: 0.9211695194, green: 0.9211695194, blue: 0.9211695194, alpha: 1)
    static let textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
}
