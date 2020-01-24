//
//  GradientView.swift
//  Dashboard
//
//  Created by Raja Bhuma on 29/03/18.
//  Copyright © 2018 CleanseCar. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientView: UIView {
    @IBInspectable
    public var startColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var startpoint: CGPoint =  CGPoint(x: 0.0, y: 1.0){
        didSet {
            gradientLayer.startPoint = startpoint
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endpoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
        didSet {
            gradientLayer.endPoint = endpoint
            setNeedsDisplay()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        gradientLayer.startPoint = startpoint
        gradientLayer.endPoint = endpoint
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
