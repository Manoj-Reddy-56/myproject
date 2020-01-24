//
//  DataExtension.swift
//  CleanseCar
//
//  Created by Raja Bhuma on 02/03/18.
//  Copyright © 2018 CleanseCar. All rights reserved.
//

import Foundation

extension NSData {
    
    func contentTypeForImag() -> String {
        
        var c: __uint8_t = 0x10
        
        self.getBytes(&c, length: 1)
        
        switch c {
        case 0xFF:
            return "image/jpeg";
        case 0x89:
            return "image/png";
        case 0x47:
            return "image/gif";
        case 0x49:
            return "image/tiff"
        case 0x4D:
            return "image/tiff";
        default:
            return "octet-stream"
        }
    }
}
