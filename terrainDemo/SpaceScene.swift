//
//  SpaceScene.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/8/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation

import Foundation
import SceneKit
//import SceneKit.ModelIO

class SpaceScene: SCNScene {
   // let cameraNode = CameraNode()
    
    override init()
    {
        super.init()

        self.background.contents = [NSImage(named:"spaceRT"),NSImage(named:"spaceLF"),NSImage(named:"spaceUP"),NSImage(named:"spaceDN"),NSImage(named:"spaceBK"),NSImage(named:"spaceFT")]
        
        let planet = PlanetNode(radius: CGFloat(28000), position:SCNVector3(0,-25050,0), segmentCount:500)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 7000, z: -1800)
        
        
        self.rootNode.addChildNode(planet)
        self.rootNode.addChildNode(lightNode)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
