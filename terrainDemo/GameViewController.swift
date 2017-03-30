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

class GameViewController: NSViewController, SCNSceneRendererDelegate, GameViewDelegate, TileGeneratorDelegate {
    
    let sky = MDLSkyCubeTexture(name: nil,
        channelEncoding: MDLTextureChannelEncoding.uInt8,
        textureDimensions: [Int32(1080), Int32(1080)],
        turbidity: 0.5,
        sunElevation: 0.6,
        upperAtmosphereScattering: 0.5,
        groundAlbedo: 0.4)
    
    
    
    let scene:SCNScene = SCNScene()
    let cameraNode:SCNNode = SCNNode()
    var tileGenerator:TileGenerator = TileGenerator() //this is dumb TODO: make this class nullable
    var isMoving = 0
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        
        // create a new scene
       
        
        
        
        let camera:SCNCamera = SCNCamera()
        camera.zNear = 0.1
        camera.zFar = 40000
        sky.groundColor = CGColor(red: 0.3,green: 0.1,blue: 0.8,alpha: 1.0)
        
        
        cameraNode.camera = camera
      //  cameraNode.addParticleSystem(SCNParticleSystem(named: "rain", inDirectory: nil)!)
        cameraNode.position = SCNVector3Make(1500,600,1500)
        tileGenerator = TileGenerator(position: CGPoint(x: cameraNode.position.x,y: cameraNode.position.z), delegate: self)
        //cameraNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(-M_PI_2))
      
        scene.rootNode.addChildNode(cameraNode)
        
        scene.fogEndDistance = 11000
        scene.fogEndDistance = 15000
        scene.fogDensityExponent = 3.0
        

        scene.fogColor = NSColor(cgColor: sky.groundColor!)!
        
        
        let floor = SCNFloor()
        floor.reflectivity = 0.0
       // floor.reflectionFalloffStart = 0.0
        floor.firstMaterial?.diffuse.contents = NSColor(red: 0.0, green: 0.0, blue: 0.3, alpha: 0.8)
        floor.firstMaterial?.reflective.contents = self.sky.imageFromTexture()?.takeUnretainedValue()
        scene.rootNode.addChildNode(SCNNode(geometry:floor))
        
        
        let seaFloor = SCNFloor()
        seaFloor.reflectivity = 0.0
        let seaFloorNode = SCNNode(geometry:seaFloor)
        seaFloorNode.position = SCNVector3Make(0,-500,0)
        scene.rootNode.addChildNode(seaFloorNode)
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 7000, z: -1800)
        cameraNode.addChildNode(lightNode)
        
        scene.background.contents = self.sky.imageFromTexture()?.takeUnretainedValue()
        
        // set the scene to the view
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = false
        
        // show statistics such as fps and timing information
      //  self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.white
        
        self.gameView.delegate = self
        self.gameView.viewDelegate = self
        
        self.gameView.isPlaying = true
        self.gameView.antialiasingMode = SCNAntialiasingMode.multisampling16X
        gameView.window?.makeFirstResponder(gameView)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let b = Basis(node: cameraNode).zAxis
        
        if(Keyboard.sharedKeyboard.justPressed(Key.down)){ isMoving = -1 }
        else if(Keyboard.sharedKeyboard.justPressed(Key.up)){ isMoving = 1 }
        if(Keyboard.sharedKeyboard.justReleased(Key.up) || Keyboard.sharedKeyboard.justReleased(Key.down)){ isMoving = 0; print("released")  }
        
        
        
        
        
        if(isMoving != 0){
            cameraNode.position.x -= b.x*15*CGFloat(isMoving)
            cameraNode.position.z -= b.z*15*CGFloat(isMoving)
        }
        
       
        tileGenerator.generateTilesForPosition(cameraNode.position)
    }
    
    
    
    
    func didMoveMouse(_ event:NSEvent) {
       // print(event)
    }
    
    func didDragMouse(_ event:NSEvent) {
//        print(event)
        self.rotateCamByAmount(CGSize(width: (-event.deltaX / 10),height: (-event.deltaY / 10)))
       
    }
    
    func rotateCamByAmount(_ amount:CGSize){
        
    
    let xAngle = SCNMatrix4MakeRotation(degToRad(0), 1, 0, 0)
    let yAngle = SCNMatrix4MakeRotation(degToRad(Float(amount.width)), 0, 1, 0)
    let zAngle = SCNMatrix4MakeRotation(degToRad(0), 0, 0, 1)
    
    let rotationMatrix = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
    cameraNode.transform = SCNMatrix4Mult(rotationMatrix, cameraNode.transform)

    
    }

    func degToRad(_ deg: Float) -> CGFloat {
        return CGFloat(deg / 180 * Float(M_PI))
    }
    
//MARK: Tile Generator Delegate
    func placeTile(_ tile: TerrainTile) {
        tile.opacity = 0.01
        scene.rootNode.addChildNode(tile)
        let fadeAction = SCNAction.fadeIn(duration: 1.0)
        fadeAction.timingMode = .linear
        fadeAction.timingFunction = {(time) in
            return time
        };
        tile.runAction(fadeAction)
        //print(tile.hashValue)
    }
    
    func removeTile(_ tile: TerrainTile) {
        let fadeAction = SCNAction.fadeOut(duration: 1.0)
        tile.runAction(fadeAction) { 
            tile.removeFromParentNode()
        }

    }
   
}
