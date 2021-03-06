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

func ==(lhs: TerrainTile, rhs: TerrainTile) -> Bool{
    return lhs.hashValue == rhs.hashValue
}

class TerrainTile: SCNNode {
   
    
    
    
    override var hashValue : Int {
        get {
            return "\(self.point.x),\(self.point.y)".hashValue
        }
    }
    
    var mat:SCNMaterial = SCNMaterial()
    var point:CGPoint
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
        point = position
        super.init()
        var terrainGeometry = terrain(size, noiseOffset:position, segmentCount:segmentCount, amplitude:elevation, floor:seaLevel)
      
       // let checkerboard:NSImage = NSImage(named:"checkerboard.png")!
        
        
        let bundle = Bundle.main
        let surfacePath = bundle.path(forResource: "heightmap", ofType: "shader")
        
    //    let lightingPath = bundle.pathForResource("toon", ofType: "shader")        // toon shader for ships
        
        
        //reading
        do {
            let text = try NSString(contentsOfFile: surfacePath!, encoding: String.Encoding.utf8.rawValue)
            //  let text2 = try NSString(contentsOfFile: lightingPath!, encoding: NSUTF8StringEncoding)
            mat.shaderModifiers = [SCNShaderModifierEntryPoint.surface : text as String]
            
            
        }
        catch {
            
            
        }

        
        //mat.diffuse.contents = checkerboard
       // mat.diffuse.contentsTransform = SCNMatrix4MakeScale(20,20,20);
        mat.diffuse.wrapT = SCNWrapMode.repeat
        mat.diffuse.wrapS = SCNWrapMode.repeat
        

        mat.isDoubleSided = true
        mat.specular.contents = NSColor.white
        terrainGeometry.materials = [mat]
        self.position = SCNVector3Make(-position.x, 10, position.y)

        
        let xAngle = SCNMatrix4MakeRotation(degToRad(90), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(degToRad(0), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(degToRad(180), 0, 0, 1)
        
        var rotationMatrix = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        
        self.transform = SCNMatrix4Mult(rotationMatrix, self.transform)
       
        self.geometry = terrainGeometry
        
        
    }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    func degToRad(_ deg: Float) -> CGFloat {
        return CGFloat(deg / 180 * Float(M_PI))
    }
}
