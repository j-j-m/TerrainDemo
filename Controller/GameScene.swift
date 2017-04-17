//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit
import Peertalk


class GameScene: SKScene {
    
    
    var appleNode: SKSpriteNode?
    let setJoystickStickImageBtn = SKLabelNode(), setJoystickSubstrateImageBtn = SKLabelNode()
    
    var joystickStickImageEnabled = true {
        
        didSet {
            
            let image = joystickStickImageEnabled ? UIImage(named: "jStick") : nil
            moveAnalogStick.stick.image = image
            rotateAnalogStick.stick.image = image
                }
    }
    
    var joystickSubstrateImageEnabled = true {
        
        didSet {
            
            let image = joystickSubstrateImageEnabled ? UIImage(named: "jSubstrate") : nil
            moveAnalogStick.substrate.image = image
            rotateAnalogStick.substrate.image = image
        }
    }
    
    let moveAnalogStick =  🕹(diameter: 200)
    let rotateAnalogStick = 🕹(diameter: 200)
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        backgroundColor = UIColor.black
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 15, y: moveAnalogStick.radius + 15)
        addChild(moveAnalogStick)
        
        rotateAnalogStick.position = CGPoint(x: self.frame.maxX - rotateAnalogStick.radius - 15, y:rotateAnalogStick.radius + 15)
        addChild(rotateAnalogStick)
        
        //MARK: Handlers begin
        
        moveAnalogStick.startHandler = { [unowned self] in
            
//            guard let aN = self.appleNode else { return }
//            aN.run(SKAction.sequence([SKAction.scale(to: 0.5, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)]))
        }
        
        moveAnalogStick.trackingHandler = { [unowned self] data in
            let event: Data = XYL(data.velocity.x, data.velocity.y).toJSON()!
            print(event)
            SocketClient.shared.send(event)
           // ConnectionManager.sendEvent(event: Event.XY, object: event )
//            guard let aN = self.appleNode else { return }
//            aN.position = CGPoint(x: aN.position.x + (data.velocity.x * 0.12), y: aN.position.y + (data.velocity.y * 0.12))
        }
        
        moveAnalogStick.stopHandler = { [unowned self] in
            
//            guard let aN = self.appleNode else { return }
//            aN.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.5), SKAction.scale(to: 1, duration: 0.5)]))
        }
        
        rotateAnalogStick.trackingHandler = { [unowned self] data in
            let event: Data = XYR(data.velocity.x, data.velocity.y).toJSON()!
            print(event)
            SocketClient.shared.send(event)
            // ConnectionManager.sendEvent(event: Event.XY, object: event )
            //            guard let aN = self.appleNode else { return }
            //            aN.position = CGPoint(x: aN.position.x + (data.velocity.x * 0.12), y: aN.position.y + (data.velocity.y * 0.12))
        }
        
        rotateAnalogStick.stopHandler =  { [unowned self] in
            
//            guard let aN = self.appleNode else { return }
//            aN.run(SKAction.rotate(byAngle: 3.6, duration: 0.5))
        }
        
        //MARK: Handlers end
        
        let selfHeight = frame.height
        let btnsOffset: CGFloat = 10
        let btnsOffsetHalf = btnsOffset / 2
    
        
        joystickStickImageEnabled = true
        joystickSubstrateImageEnabled = true
        
      
        
        setStickColor()
        setSubstrateColor()
  //      addApple(CGPoint(x: frame.midX, y: frame.midY))
        
        view.isMultipleTouchEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            
            let node = atPoint(touch.location(in: self))
            
            switch node {
                
            case setJoystickStickImageBtn:
                joystickStickImageEnabled = !joystickStickImageEnabled
            case setJoystickSubstrateImageBtn:
                joystickSubstrateImageEnabled = !joystickSubstrateImageEnabled

            default:
                break
            }
        }
    }
    
    
    
    func setStickColor() {
        
        let color = UIColor.cyan.withAlphaComponent(0.5)
        moveAnalogStick.stick.color = color
        rotateAnalogStick.stick.color = color
    }
    
    func setSubstrateColor() {
        
        let color = UIColor.darkGray.withAlphaComponent(0.3)
        moveAnalogStick.substrate.color = color
        rotateAnalogStick.substrate.color = color
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

extension UIColor {
    
    static func random() -> UIColor {
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
