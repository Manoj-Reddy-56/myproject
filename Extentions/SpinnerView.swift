//
//  SpinnerView.swift
//  Pocofy
//
//  Created by Raja Bhuma on 27/03/18.
//  Copyright © 2018 Pocofy. All rights reserved.
//

import UIKit

@IBDesignable
class SpinnerView: UIView {

    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        setPath()
        
        self.CornerRadiusMulti = 2
        self.clipsToBounds = true
        self.backgroundColor = UIColor.TheamColor
        
        self.isHidden = true
    }
    
    override func didMoveToWindow() {
//        animate()
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: bounds.size.height*0.25, dy: bounds.size.height*0.25)).cgPath
    }
    
    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }
    
    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.7),
                Pose(0.6, 1.000, 0.7),
                Pose(0.6, 1.500, 0.7),
                Pose(0.2, 1.875, 0.7),
                Pose(0.2, 2.250, 0.7),
                Pose(0.2, 2.625, 0.7),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }
    
    private func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()
        
        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }
        
        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * CGFloat(Double.pi))
            strokeEnds.append(pose.length)
        }
        
        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])
        
        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
        
    }
    
    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

    

    public func beginAnimating() {
        if self.isHidden {
            self.isHidden = false
            animate()
        }
    }
    
    public func endAnimating() {
        self.isHidden = true
        layer.removeAllAnimations()
    }
    
    typealias RefreshBlock = (Bool) -> Void
    
    var refreshBlock: RefreshBlock!
    
    public func moniterRefreshBlock(_ block:@escaping RefreshBlock) {
        refreshBlock = block
    }
    
    public func pullDown(scrollView: UIScrollView, decelerate: Bool) {
        if scrollView.contentOffset.y < -60 {
            if decelerate {
                refreshBlock(true)
            }
        }
    }
}
