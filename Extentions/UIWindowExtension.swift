//
//  UIWindowExtension.swift
//  Pocofy
//
//  Created by Raja Bhuma on 15/12/17.
//  Copyright © 2017 Pocofy. All rights reserved.
//

import UIKit

extension UIWindow {
    class func TopLevelController()-> UIViewController {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        return window.rootViewController!
    }
}
