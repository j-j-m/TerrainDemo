//
//  GameView.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/16/15.
//  Copyright (c) 2015 Jacob Martin. All rights reserved.
//

import SceneKit

class GameView: SCNView {
    var viewDelegate: GameViewDelegate?
   
    
    

    override func mouseMoved(theEvent: NSEvent) {
        super.mouseMoved(theEvent)
        self.viewDelegate?.didMoveMouse(theEvent)
    }
//    override func mouseDown(theEvent: NSEvent) {
//        /* Called when a mouse click occurs */
//        
//        // check what nodes are clicked
//        let p = self.convertPoint(theEvent.locationInWindow, fromView: nil)
//        let hitResults = self.hitTest(p, options: nil)
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            // retrieved the first clicked object
//            let result: AnyObject = hitResults[0]
//            
//            // get its material
//            let material = result.node!.geometry!.firstMaterial!
//            
//            // highlight it
//            SCNTransaction.begin()
//            SCNTransaction.setAnimationDuration(0.5)
//            
//            // on completion - unhighlight
//            SCNTransaction.setCompletionBlock() {
//                SCNTransaction.begin()
//                SCNTransaction.setAnimationDuration(0.5)
//                
//                material.emission.contents = NSColor.blackColor()
//                
//                SCNTransaction.commit()
//            }
//            
//            material.emission.contents = NSColor.redColor()
//            
//            SCNTransaction.commit()
//        }
//        
//        super.mouseDown(theEvent)
//    }
    
    override func keyUp(theEvent: NSEvent) {
        Keyboard.sharedKeyboard.handleKey(theEvent, isDown: false)
        Keyboard.sharedKeyboard.update()
        
    }
    
    override func keyDown(theEvent: NSEvent) {
        Keyboard.sharedKeyboard.handleKey(theEvent, isDown: true)
        
       self.playing = true
    }
    
    
    
    
    override func mouseDragged(theEvent: NSEvent) {
        self.viewDelegate?.didDragMouse(theEvent)
    }
   

}



protocol GameViewDelegate {
    
    func didMoveMouse(event:NSEvent)
    func didDragMouse(event:NSEvent)
}

