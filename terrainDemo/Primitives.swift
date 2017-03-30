//
//  Primitives.swift
//  NoiseGeometry
//
//  Created by Jacob Martin on 11/3/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit
import QuartzCore


func toSpherical(_ x:Float, y:Float, z:Float) -> CGPoint{
    let norm:Float = sqrt(pow(x, 2)+pow(y, 2)+pow(z, 2))
    var point:CGPoint = CGPoint(x: acos(CGFloat(z/norm)), y: atan(CGFloat(y/x)))
    if (point.y.isNaN){
        point.y = 0
    }
    if (point.x.isNaN){
        point.x = 0
    }
    
    return point
}



func geoSphere(_ radius:CGFloat, segmentCount:Int, amplitude:CGFloat, floor:CGFloat, octaves:Int, frequency:CGFloat) -> SCNGeometry{
    
    let sph:SCNSphere = SCNSphere(radius: radius)
    
    
    SCNTransaction.begin()
    sph.isGeodesic = true
    sph.segmentCount = segmentCount
    
    SCNTransaction.commit()
    
    let vertex_src = sph.getGeometrySources(for: SCNGeometrySource.Semantic.vertex)[0]    //pull out vertex data
    let normal_src = sph.getGeometrySources(for: SCNGeometrySource.Semantic.normal)[0]    //and surface normal data
    let texture_src = sph.getGeometrySources(for: SCNGeometrySource.Semantic.texcoord)[0] //as well as texture coordinate data so we may keep the same texture mapping
    
    let stride:NSInteger = vertex_src.dataStride; // in bytes
    let offset:NSInteger = vertex_src.dataOffset; // in bytes
    
    let componentsPerVector:NSInteger = vertex_src.componentsPerVector;
    let bytesPerVector:NSInteger = componentsPerVector * vertex_src.bytesPerComponent;
    let vectorCount:NSInteger = vertex_src.vectorCount;
    
    
    let count = vertex_src.data.count / MemoryLayout<Float>.size
    
    var vertArray = [Float](repeating: 0, count: count)
    (vertex_src.data as NSData).getBytes(&vertArray, length:count * MemoryLayout<Float>.size)
   



    for i:NSInteger in 0 ..< vectorCount {
        // The range of bytes for this vector
        let byteRange: NSRange = NSMakeRange(i*stride + offset, // Start at current stride + offset
            bytesPerVector);   // and read the lenght of one vector
        
        // create array of appropriate length:
        var array = [Float](repeating: 0, count: 3)
        var normalArray = [Float](repeating: 0, count: 3)
        // copy bytes into array
        
        (vertex_src.data as NSData).getBytes(&array, range: byteRange)
        (normal_src.data as NSData).getBytes(&normalArray, range: byteRange)
        
        // At this point you can read the data from the float array
       // let octaves = 10
        
      //  var factor:Double = Double(norm3D(array[0], y:array[1] , z: array[2]))
        var factor = 7.0
     //   print(simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor))
        
        var disp:Double = 0.0
        //disp = simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor)
        for o in 1...octaves{
            disp += simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor)
            factor *= 2
        }
        
        disp = disp/Double(octaves)
        disp = disp/Double(amplitude)
        
        
      
        var x,y,z:Float
        if(radius+CGFloat(disp)<floor){
            x = array[0]    //lost precision but okay for now
            y = array[1]
            z = array[2]
        }
        else{
        
        x = array[0]+normalArray[0]*Float(disp)    //lost precision but okay for now
        y = array[1]+normalArray[1]*Float(disp)
        z = array[2]+normalArray[2]*Float(disp)
        }
        
        vertArray[3*i] = x
        vertArray[(3*i)+1] = y
        vertArray[(3*i)+2] = z
        
        
    }

   
    let data:Data = Data(bytes: vertArray, count: Int(vectorCount * 3 * MemoryLayout<Float>.size))
    let source:SCNGeometrySource = SCNGeometrySource(data:data,
        semantic:SCNGeometrySource.Semantic.vertex,
        vectorCount:vectorCount,
        usesFloatComponents:true,
        componentsPerVector:3,
        bytesPerComponent:MemoryLayout<Float>.size,
        dataOffset:0,
        dataStride:MemoryLayout<Float>.size*3)
    
    
    
    
    
    
    let geomElement:SCNGeometryElement = SCNGeometryElement(           
        data: sph.geometryElement(at: 0).data,
        primitiveType: SCNGeometryPrimitiveType.triangles,
        primitiveCount: sph.geometryElement(at: 0).primitiveCount,
        bytesPerIndex: 2)
    
    
    let geometry:SCNGeometry = SCNGeometry(sources:[source, normal_src, texture_src], elements:[geomElement])
    

    
    return geometry

}


func terrain(_ size:CGSize, noiseOffset:CGPoint, segmentCount:Int, amplitude:CGFloat, floor:CGFloat)->SCNGeometry{
    let pln:SCNPlane = SCNPlane(width: size.width, height: size.height)
    
    
    
    SCNTransaction.begin()
  
    pln.widthSegmentCount = segmentCount
    pln.heightSegmentCount = segmentCount

    SCNTransaction.commit()
    
    let vertex_src = pln.getGeometrySources(for: SCNGeometrySource.Semantic.vertex)[0]    //pull out vertex data
    let normal_src = pln.getGeometrySources(for: SCNGeometrySource.Semantic.normal)[0]    //and surface normal data
    let texture_src = pln.getGeometrySources(for: SCNGeometrySource.Semantic.texcoord)[0] //as well as texture coordinate data so we may keep the same texture mapping
    
    let stride:NSInteger = vertex_src.dataStride; // in bytes
    let offset:NSInteger = vertex_src.dataOffset; // in bytes
    
    let componentsPerVector:NSInteger = vertex_src.componentsPerVector;
    let bytesPerVector:NSInteger = componentsPerVector * vertex_src.bytesPerComponent;
    let vectorCount:NSInteger = vertex_src.vectorCount;
    
    
    let count = vertex_src.data.count / MemoryLayout<Float>.size
    
    var vertArray = [Float](repeating: 0, count: count)
    (vertex_src.data as NSData).getBytes(&vertArray, length:count * MemoryLayout<Float>.size)
    
    
    
    
    for i:NSInteger in 0 ..< vectorCount {
        // The range of bytes for this vector
        let byteRange: NSRange = NSMakeRange(i*stride + offset, // Start at current stride + offset
            bytesPerVector);   // and read the lenght of one vector
        
        // create array of appropriate length:
        var array = [Float](repeating: 0, count: 3)
        var normalArray = [Float](repeating: 0, count: 3)
        // copy bytes into array
        
        (vertex_src.data as NSData).getBytes(&array, range: byteRange)
        (normal_src.data as NSData).getBytes(&normalArray, range: byteRange)
        
        // At this point you can read the data from the float array
         let octaves = 10
        
        //  var factor:Double = Double(norm3D(array[0], y:array[1] , z: array[2]))
        var factor = 10.0
        //   print(simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor))
        
        var disp:Double = 0.0
        //disp = simplexNoise3D(Double(array[0])/factor, y: Double(array[1])/factor, z: Double(array[2])/factor)
        for o in 1...octaves{
            disp += simplexNoise2D(Double(array[0]+Float(noiseOffset.x))/factor,
                y: Double(array[1]+Float(noiseOffset.y))/factor)*pow(Double(o),Double(3))
            factor *= 6
        }
        
        
        
        disp = disp/Double(octaves)
        disp = disp/Double(amplitude)
        
        
        
        var x,y,z:Float
//        if(CGFloat(disp)<floor){
//            x = array[0]    //lost precision but okay for now
//            y = array[1]
//            z = array[2]
//        }
//        else{
        
            x = array[0]
            y = array[1]
            z = array[2]+100.0*Float(disp)
//        }
        
        vertArray[3*i] = x
        vertArray[(3*i)+1] = y
        vertArray[(3*i)+2] = z
        
        
    }
    
    
   
    let data:Data = Data(bytes: vertArray, count: Int(vectorCount * 3 * MemoryLayout<Float>.size))
    
    let source:SCNGeometrySource = SCNGeometrySource(data:data,
        semantic:SCNGeometrySource.Semantic.vertex,
        vectorCount:vectorCount,
        usesFloatComponents:true,
        componentsPerVector:3,
        bytesPerComponent:MemoryLayout<Float>.size,
        dataOffset:0,
        dataStride:MemoryLayout<Float>.size*3)
    
    
    
    
    
    
    let geomElement:SCNGeometryElement = SCNGeometryElement(
        data: pln.geometryElement(at: 0).data,
        primitiveType: SCNGeometryPrimitiveType.triangles,
        primitiveCount: pln.geometryElement(at: 0).primitiveCount,
        bytesPerIndex: 2)
    
    
    let geometry:SCNGeometry = SCNGeometry(sources:[source, normal_src, texture_src], elements:[geomElement])
    
    
    
    return geometry

}




func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
    return value.withUnsafeBytes {
        $0.baseAddress!.load(as: T.self)
    }
}


