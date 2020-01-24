//
//  UILabelExtension.swift
//  Pocofy
//
//  Created by Raja Bhuma on 08/12/17.
//  Copyright © 2017 Pocofy. All rights reserved.
//

import UIKit

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
    var getWidth: CGFloat {
        return CGFloat(self.frame.size.width)
    }
}
