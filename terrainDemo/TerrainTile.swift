//
//  TerrainTile.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/12/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit
import simd


// ⛰🏔🗻
// ⛰🗻🏔  tile for terrain generator
// 🗻⛰🏔

class TerrainTile: SCNNode {
    
    
    /**
     Creates a new planet node with displaced by simplex noise.
     
     - Parameters:
     - radius: radius of shpere before displacement
     - elevation: elevation of noise (amplitude)
     - seaLevel: the sea level... isnt imlemented at the moment. need to figure out the face overlap jitter problem
     - segmentCount: segment count of the sphere... in this case logarithmic because it is a geosphere
     
     - Returns: SCNNode containing the layers of a planet along with material
     
     */
    
    init(size:CGSize, position:CGPoint, elevation:CGFloat, seaLevel:CGFloat, segmentCount:Int){
        super.init()
        var terrainGeometry = terrain(size, noiseOffset:position, segmentCount:segmentCount, amplitude:elevation, floor:seaLevel)
      
        let checkerboard:NSImage = NSImage(named:"checkerboard.png")!
        
        
        var mat:SCNMaterial = SCNMaterial()
        mat.diffuse.contents = checkerboard
        mat.diffuse.contentsTransform = SCNMatrix4MakeScale(4,4,4);
        mat.diffuse.wrapT = SCNWrapMode.Repeat
        mat.diffuse.wrapS = SCNWrapMode.Repeat
       // terrainGeometry.firstMaterial = mat
        self.position = SCNVector3Make(position.x, position.y, 0)
        self.geometry = terrainGeometry
        
        
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}