//
//  TileGenerator.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/16/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation
import SceneKit

class TileGenerator: NSObject {

    var delegate:TileGeneratorDelegate?
    var tileSize:CGSize = CGSize(width: 1000, height: 1000)
    var tileDictionary:[String:TerrainTile] = Dictionary()
    var lastReferencePoint:CGPoint = CGPoint(x: 0, y: 0)
    var gridSize:CGFloat = 20
    var mutex:Bool = true
    override init(){
        super.init()
    }
    
    init(position:CGPoint, delegate:TileGeneratorDelegate){
        self.delegate = delegate
        super.init()

        
     
    }
    
    func generateTilesForPosition(_ position:SCNVector3){
       
        if(mutex){
        self.mutex=false
        let qualityOfServiceClass = DispatchQoS.QoSClass.userInteractive
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
        
        let ref:CGPoint = CGPoint(x: FASTFLOOR(position.x/self.tileSize.width), y: FASTFLOOR(-position.z/self.tileSize.height))

            
        if(self.lastReferencePoint != ref){

            print(position)
            var count:Int = 0
            var newKeys:[String] = [String]()
            var oldKeys:[String] = [String]()
            for i in Int(ref.x-self.gridSize)...Int(ref.x+self.gridSize){
                for j in Int(ref.y-self.gridSize)...Int(ref.y+self.gridSize){
                   let refPoint = "\(i),\(j)"
                    let point = CGPoint(x: CGFloat(-i)*self.tileSize.width, y: CGFloat(-j)*self.tileSize.width)
                    
                    if(self.tileDictionary[refPoint] == nil){
                      count += 1
                        
                        newKeys.append(refPoint)
                        
                           let tile = TerrainTile(size: self.tileSize,position:point, elevation: 5, seaLevel: 0, segmentCount: 20)
                            self.tileDictionary[refPoint] = tile
                            self.delegate!.placeTile(tile)
                    }
                    else{
                       oldKeys.append(refPoint)
                    }
                   
                }
            }
            
            var keys = Array(self.tileDictionary.keys)
           
            keys.removeObjectsInArray(newKeys+oldKeys)
            
            for k in keys{
               let badTile = self.tileDictionary[k]
                self.tileDictionary.removeValue(forKey: k)
                self.delegate!.removeTile(badTile!)
            }
   
            self.lastReferencePoint = ref
        }
        
        self.mutex = true
    })
    
        }
    }


}

protocol TileGeneratorDelegate{
    func placeTile(_ tile:TerrainTile)
    func removeTile(_ tile:TerrainTile)
}
