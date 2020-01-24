//
//  UITextviewExtension.swift
//  Pocofy
//
//  Created by Raja Bhuma on 03/12/17.
//  Copyright © 2017 Pocofy. All rights reserved.
//

import UIKit
import CoreText
import MobileCoreServices

extension UITextView {
    
    func getLinesArray() -> [String] {
        
        let modifyText = self.text!
        let font = self.font!
        let rect = self.frame
        
        let myFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        let attStr = NSMutableAttributedString.init(string: modifyText)
        attStr.addAttribute(.font, value: myFont, range: NSMakeRange(0, attStr.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        
        let path = CGMutablePath()
        
        path.addRect(CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: rect.size.width, height: 100000)))
        
        let frameCT = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        let lines = CTFrameGetLines(frameCT) as Array
        
        var linesArray = [String]()
        
        for line in lines {
            
            let lineref = line as! CTLine
            
            let lineRange = CTLineGetStringRange(lineref)
            
            let range = NSMakeRange(lineRange.location, lineRange.length)
            
            let lineString = (modifyText as NSString).substring(with: range)
            
            CFAttributedStringSetAttribute(attStr as CFMutableAttributedString, lineRange, kCTKernAttributeName, NSNumber.init(value: 0.0) as CFTypeRef)
            CFAttributedStringSetAttribute(attStr as CFMutableAttributedString, lineRange, kCTKernAttributeName, NSNumber.init(value: 0.0) as CFTypeRef)

            linesArray.append(lineString)
        }
        
        return linesArray
    }
    
}
