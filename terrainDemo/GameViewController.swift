//
//  GameViewController.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/16/15.
//  Copyright (c) 2015 Jacob Martin. All rights reserved.
//

import SceneKit
import SpriteKit
import QuartzCore
import ModelIO


class GameViewController: NSViewController, SCNSceneRendererDelegate, GameViewDelegate, TileGeneratorDelegate {
    
    
    var sky = MDLSkyCubeTexture(name: nil,
        channelEncoding: MDLTextureChannelEncoding.uInt8,
        textureDimensions: [Int32(160), Int32(160)],
        turbidity: 0.5,
        sunElevation: 0.5,
        upperAtmosphereScattering: 1.0,
        groundAlbedo: 1.0)
    
    let queue = DispatchQueue(label: "TextureUpdateQueue")
    var busy =  false // indicates MDLSkyCubeTexture is updating
    var changePending = false // indicates a pending user change
    
    let scene:SCNScene = TerrestrialScene()
    let spaceScene:SCNScene = SpaceScene()
    let cameraNode:SCNNode = SCNNode()
    var tileGenerator:TileGenerator = TileGenerator() 
    var isMoving = 0
    var movingVertical = false
    let upperAtmosphereElevation:CGFloat = 2000.0
    let spaceElevation:CGFloat = 3000.0
       
    
    var isInUpperAtmosphere = false {
        didSet {
            
            guard !busy else
            {
                changePending = true
                return
            }
            
            busy = true
            
            
            queue.async{
                if self.isInUpperAtmosphere {
                    let p = (self.spaceElevation - self.cameraNode.position.y)/(self.spaceElevation-self.upperAtmosphereElevation)
                    
                    self.sky.turbidity = Float(p)/2
                    self.sky.upperAtmosphereScattering = Float(p)
                    self.sky.groundAlbedo = Float(p)
                    self.sky.update()
                    self.scene.background.contents = self.sky.imageFromTexture()?.takeUnretainedValue()
                }
                else {
                    self.sky.turbidity = 0.5
                    self.sky.upperAtmosphereScattering = 1.0
                    self.sky.update()
                    self.scene.background.contents = self.sky.imageFromTexture()?.takeUnretainedValue()
                }
                
                DispatchQueue.main.async {
                    self.busy = false
                    
                    if self.changePending
                    {
                        self.changePending = false
                    }
                }
            }
            
            
        }
    }
    
        var isInSpace = false {
            didSet {
                
                var transition = SKTransition.crossFade(withDuration: 0.1)
                transition.pausesIncomingScene = false
                transition.pausesOutgoingScene = false
                
                if isInSpace && oldValue == false {
                    self.cameraNode.camera?.focalBlurRadius = 0.0
                    gameView.present(spaceScene, with: transition, incomingPointOfView: self.cameraNode) {
                        print("trans to space")
                    }
                }
                else if !isInSpace && oldValue == true {
                    gameView.present(scene, with: transition, incomingPointOfView: self.cameraNode) {
                        print("trans to planet")
                    }
                }
            }
        }
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        
        
        let camera:SCNCamera = SCNCamera()
        camera.zNear = 0.1
        camera.zFar = 40000
        camera.focalDistance = 5.0
        camera.focalSize = 4.5
        camera.focalBlurRadius = 12.0
        
        
        //camera.aperture = 0.18
        
        
        if #available(OSX 10.12, *) {
           
            camera.bloomIntensity = 1.4
            camera.bloomBlurRadius = 1.0
//            camera.colorFringeStrength = 1.0
//            camera.colorFringeIntensity = 1.0
           // camera.wantsHDR = true
        }
        sky.groundColor = CGColor(red: 0.1,green: 0.7,blue: 0.8,alpha: 1.0)
        
        
        cameraNode.camera = camera
      //  cameraNode.addParticleSystem(SCNParticleSystem(named: "rain", inDirectory: nil)!)
        cameraNode.position = SCNVector3Make(0,600,0)
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
        
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
            self.keyUp(with: $0)
            return $0
        }
        gameView.window?.makeFirstResponder(gameView)
        
        
        ControlHandler(with: cameraNode){
            self.tileGenerator.generateTilesForPosition(self.cameraNode.position)
        }
        
        
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let b = Basis(node: cameraNode).zAxis

        
        
        if(isMoving != 0){
            if !movingVertical {
            cameraNode.position.x -= b.x*10*CGFloat(isMoving)
            cameraNode.position.z -= b.z*10*CGFloat(isMoving)
            }
            else {
                cameraNode.position.y += 5*CGFloat(isMoving)
                if cameraNode.position.y > spaceElevation {
                    isInSpace = true
                }
                else if cameraNode.position.y > upperAtmosphereElevation {
                    isInUpperAtmosphere = true
                    isInSpace = false
                }
                else {
                    isInSpace = false
                   isInUpperAtmosphere = false
                }
//                print(cameraNode.position.y)
               // sky.update()
            }
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
        
    
    let xAngle = SCNMatrix4MakeRotation(degToRad(Float(amount.width)), 1, 0, 0)
    let yAngle = SCNMatrix4MakeRotation(degToRad(0), 0, 1, 0)
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
   
    override func keyDown(with event: NSEvent) {
        Keyboard.sharedKeyboard.handleKey(event, isDown: true)
        
        if(Keyboard.sharedKeyboard.justPressed(Key.s)){ isMoving = -1 }
        else if(Keyboard.sharedKeyboard.justPressed(Key.w)){ isMoving = 1 }
        
        if (event.modifierFlags.contains(NSEventModifierFlags.option)){
            movingVertical = true
        }
        else {
            movingVertical = false
        }
    }
    
    override func keyUp(with event: NSEvent) {
        
        Keyboard.sharedKeyboard.handleKey(event, isDown: false)
        print(event.keyCode)
        if(Keyboard.sharedKeyboard.justReleased(Key.w) || Keyboard.sharedKeyboard.justReleased(Key.s)){
            isMoving = 0
            print("released")
        }
        
        
    }
    
    override func flagsChanged(with event: NSEvent) {
        print(event)
      //  Keyboard.sharedKeyboard.handleKey(event, isDown: false)
        
    }

}

