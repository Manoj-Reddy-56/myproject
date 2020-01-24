//
//  File.swift
//  Pocofy
//
//  Created by Raja Bhuma on 29/12/17.
//  Copyright © 2017 Pocofy. All rights reserved.
//

import UIKit

private var maxLengths = [UITextField: Int]()

@IBDesignable
extension UITextField {
    
    @IBInspectable var DoneBtn: Bool {
        set {
            if newValue {
                let donetoolbar = UIToolbar(frame : CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                
                donetoolbar.barStyle = UIBarStyle.default
                let flexspace = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let done = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(DoneAction))
                done.tintColor = UIColor.black
                donetoolbar.tintColor = UIColor.groupTableViewBackground
                donetoolbar.items = [flexspace,done]
                donetoolbar.sizeToFit()
                
                self.inputAccessoryView = donetoolbar
            }
            else {
                self.inputAccessoryView = nil
            }
            
        }
        get {
            return self.DoneBtn
        }
    }
    
    @objc func DoneAction() {
        self.resignFirstResponder()
    }
    
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControl.Event.editingChanged
            )
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }

        let selection = selectedTextRange
        
        text = String(prospectiveText[..<prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)])
        
        selectedTextRange = selection
    }
}
