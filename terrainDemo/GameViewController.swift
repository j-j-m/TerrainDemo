//
//  GameViewController.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/16/15.
//  Copyright (c) 2015 Jacob Martin. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        // create a new scene
        let scene = SCNScene()
        
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(0, 0), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(200, 0), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(0, 200), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(200, 200), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(-200, 0), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(0, -200), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(-200, -200), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(200, -200), elevation: 5, seaLevel: 0, segmentCount: 100))
        scene.rootNode.addChildNode(TerrainTile(size: CGSizeMake(200,200),position:CGPointMake(-200, 200), elevation: 5, seaLevel: 0, segmentCount: 100))
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 100)
        scene.rootNode.addChildNode(lightNode)
        
     
        // set the scene to the view
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
      //  self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.blueColor()
    }

}
