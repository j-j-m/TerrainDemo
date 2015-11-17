//
//  GameViewController.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/16/15.
//  Copyright (c) 2015 Jacob Martin. All rights reserved.
//

import SceneKit
import QuartzCore
import ModelIO

class GameViewController: NSViewController, SCNSceneRendererDelegate, GameViewDelegate {
    
    let sky = MDLSkyCubeTexture(name: nil,
        channelEncoding: MDLTextureChannelEncoding.UInt8,
        textureDimensions: [Int32(200), Int32(200)],
        turbidity: 0.5,
        sunElevation: 0.6,
        upperAtmosphereScattering: 0.7,
        groundAlbedo: 0.3)
    
    let cameraNode:SCNNode = SCNNode()
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        // create a new scene
        let scene = SCNScene()
        let camera:SCNCamera = SCNCamera()
        camera.zNear = 0.1
        camera.zFar = 1000
        
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0,20,0)
        
        scene.rootNode.addChildNode(cameraNode)
        
        let floor = SCNFloor()
        floor.firstMaterial?.diffuse.contents = NSColor.blueColor()
        scene.rootNode.addChildNode(SCNNode(geometry:floor))
        
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
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = SCNLightTypeOmni
//        lightNode.position = SCNVector3(x: 0, y: 100, z: 100)
//        scene.rootNode.addChildNode(lightNode)
        
        scene.background.contents = self.sky.imageFromTexture()?.takeUnretainedValue()
        // set the scene to the view
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = false
        
        // show statistics such as fps and timing information
      //  self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.whiteColor()
        
        self.gameView.delegate = self
        self.gameView.viewDelegate = self
        
        self.gameView.playing = true
        gameView.window?.makeFirstResponder(gameView)
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        
        if(Keyboard.sharedKeyboard.justPressed(Key.Down)){ cameraNode.position.x -= 1 }
        if(Keyboard.sharedKeyboard.justPressed(Key.Up)){ cameraNode.position.x += 1 }
    }
    
    
    
    
    func didMoveMouse(event:NSEvent) {
        print(event)
    }
    
    func didDragMouse(event:NSEvent) {
//        print(event)
        self.rotateCamByAmount(CGSizeMake((-event.deltaX / 10),(-event.deltaY / 10)))
       
    }
    
    func rotateCamByAmount(amount:CGSize){
        
    
    let xAngle = SCNMatrix4MakeRotation(degToRad(0), 1, 0, 0)
    let yAngle = SCNMatrix4MakeRotation(degToRad(Float(amount.width)), 0, 1, 0)
    let zAngle = SCNMatrix4MakeRotation(degToRad(0), 0, 0, 1)
    
    var rotationMatrix = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
    print(amount)
    cameraNode.transform = SCNMatrix4Mult(rotationMatrix, cameraNode.transform)

    }

    func degToRad(deg: Float) -> CGFloat {
        return CGFloat(deg / 180 * Float(M_PI))
    }
   
}
