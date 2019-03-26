//
//  DesignOfViews.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 8/2/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import UIKit

class DesignOfTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
            navCon.navigationBar.tintColor =  Constants.navButtonColor
            
            createGradientLayer()
        }
        
    }

    // Set gradient for navigation bar
    func createGradientLayer() {
       /* let gradientLayer = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        gradientLayer.frame = defaultNavigationBarFrame
        gradientLayer.colors = Constants.gradientColor
        
        navigationController?.navigationBar.setBackgroundImage(self.image(fromLayer: gradientLayer), for: .default)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        //Create View behind navigation bar and add gradient
        let behindView = UIView(frame: CGRect(x: 0, y:0, width: UIApplication.shared.statusBarFrame.width, height: UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Constants.gradientColor
        behindView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.navigationController?.view.insertSubview(behindView, belowSubview: navigationController!.navigationBar)*/



    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    
}

class DesignOfViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
            navCon.navigationBar.tintColor = Constants.navButtonColor
        }
    }
}

class DesignOfTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navCon.navigationBar.barTintColor = Constants.barColor
            navCon.navigationBar.titleTextAttributes = Constants.textAttributes
            navCon.navigationBar.largeTitleTextAttributes = Constants.textAttributes
           navCon.navigationBar.tintColor = Constants.navButtonColor

        }
        tabBar.barTintColor = Constants.barColor
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = Constants.buttonColor
    }
}

