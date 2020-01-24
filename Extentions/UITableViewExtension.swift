//
//  File.swift
//  Pocofy
//
//  Created by Raja Bhuma on 18/02/18.
//  Copyright © 2018 Pocofy. All rights reserved.
//

import UIKit

extension UITableView {
    func addFooterLoader() {
        let activaty = UIActivityIndicatorView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.bounds.size.width, height: 45)))
        activaty.color = UIColor.TheamColor
        activaty.startAnimating()
        self.tableFooterView = activaty
    }
    func removeFooter() {
        self.tableFooterView = UIView.init(frame: .zero)
    }
}
