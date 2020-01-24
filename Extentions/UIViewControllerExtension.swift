//
//  UIViewControllerExtension.swift
//  CarPol
//
//  Created by Raja Bhuma on 31/08/17.
//  Copyright © 2017 Sun Telematics Pvt Ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func controllerWithMainStoryBoard(withIdentifier: String) -> UIViewController {
        return (self.storyboard?.instantiateViewController(withIdentifier: withIdentifier))!
    }
    
    func controller(withstoryboadName: String, withIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: withstoryboadName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: withIdentifier)
    }
    
}
