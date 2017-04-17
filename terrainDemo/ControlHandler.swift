//
//  ControlHandler.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/10/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit

class ControlHandler {
    var node: SCNNode
    var runTransaction = true
    
    var lx:Float = 0.0
    var ly:Float = 0.0
    var rx:Float = 0.0
    var ry:Float = 0.0
    
    var updateBlock: () -> Void
    
    init(with node:SCNNode, update: @escaping () -> Void){
        self.node = node
        self.updateBlock = update
        GamePadServer.shared.delegate = self
     
        runUpdates()
    }
    
    func getZForward() -> SCNVector3 {
        return SCNVector3(node.worldTransform.m31, node.worldTransform.m32, node.worldTransform.m33)
    }
    
    
    func runUpdates(){
        if runTransaction {
            
            var heading:SCNVector3 = getZForward()
            heading.z = -CGFloat(ly/8)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.7
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            SCNTransaction.completionBlock = {
                self.runUpdates()
            }
            
            
            let xAngle = SCNMatrix4MakeRotation(CGFloat(ry/500), 1, 0, 0)
            let yAngle = SCNMatrix4MakeRotation(CGFloat(-lx/500), 0, 1, 0)
            let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 1)
            
            var rotationMatrix = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
            node.transform = SCNMatrix4Mult(rotationMatrix, node.transform)
            node.position.z -= CGFloat(ly*5)
            
            SCNTransaction.commit()
        }
    }
    
    
}


extension ControlHandler: GamePadServerDelegate {
    func gamepadXYLeft(_ x: Float, _ y: Float){
        
        lx = x
        ly = y

    }
    
    func gamepadXYRight(_ x: Float, _ y: Float){
        rx = x
        ry = y
    }
    
}
