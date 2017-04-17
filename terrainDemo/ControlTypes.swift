//
//  ControlTypes.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/9/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation
import CoreGraphics

enum ControlType:String {
    case XYL = "XYL", XYR = "XYR"
}
struct XYL: JSONSerializable {
    var type:String = ControlType.XYL.rawValue
    var x: Float
    var y: Float
    
    init(_ x: CGFloat, _ y: CGFloat) {
        self.x = Float(x)
        self.y = Float(y)
    }
    
}

struct XYR: JSONSerializable {
    var type:String = ControlType.XYR.rawValue
    var x: Float
    var y: Float
    
    init(_ x: CGFloat, _ y: CGFloat) {
        self.x = Float(x)
        self.y = Float(y)
    }
}
