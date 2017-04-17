//
//  PlanetNode.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/8/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit
import simd


// ⛰🏔🗻
// ⛰🗻🏔  tile for terrain generator
// 🗻⛰🏔



class PlanetNode: SCNNode {
    
    
    
    
    override var hashValue : Int {
        get {
            return "\(self.point.x),\(self.point.y)".hashValue
        }
    }
    
    var mat:SCNMaterial = SCNMaterial()
    var point:SCNVector3
    /**
     Creates a new planet node with displaced by simplex noise.
     
     - Parameters:
     - radius: radius of shpere before displacement
     - elevation: elevation of noise (amplitude)
     - seaLevel: the sea level... isnt imlemented at the moment. need to figure out the face overlap jitter problem
     - segmentCount: segment count of the sphere... in this case logarithmic because it is a geosphere
     
     - Returns: SCNNode containing the layers of a planet along with material
     
     */
    
    init(radius:CGFloat, position:SCNVector3, segmentCount:Int){
        point = position
        super.init()
        var planetGeometry = geoSphere(radius, segmentCount: segmentCount, amplitude: 200, floor: 0.1, octaves: 5, frequency: 23.0)
        
        // let checkerboard:NSImage = NSImage(named:"checkerboard.png")!
        
      
        let bundle = Bundle.main
        let surfacePath = bundle.path(forResource: "heightmap", ofType: "shader")
        
        //    let lightingPath = bundle.pathForResource("toon", ofType: "shader")        // toon shader for ships
        
        
        //reading
        do {
            let text = try NSString(contentsOfFile: surfacePath!, encoding: String.Encoding.utf8.rawValue)
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
        planetGeometry.materials = [mat]
        self.position = position

        
        self.geometry = planetGeometry
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func degToRad(_ deg: Float) -> CGFloat {
        return CGFloat(deg / 180 * Float(M_PI))
    }
}
