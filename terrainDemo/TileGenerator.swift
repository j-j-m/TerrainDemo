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
    var tileSize:CGSize = CGSizeMake(3000, 3000)
    var tileDictionary:[String:TerrainTile] = Dictionary()
    var lastReferencePoint:CGPoint = CGPointMake(0, 0)
    var gridSize:CGFloat = 7
    var mutex:Bool = true
    override init(){
        super.init()
    }
    
    init(position:CGPoint, delegate:TileGeneratorDelegate){
        self.delegate = delegate
        super.init()

        
     
    }
    
    func generateTilesForPosition(position:SCNVector3){
       
        if(mutex){
        self.mutex=false
        let qualityOfServiceClass = QOS_CLASS_USER_INTERACTIVE
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
        
        let ref:CGPoint = CGPointMake(FASTFLOOR(position.x/self.tileSize.width), FASTFLOOR(-position.z/self.tileSize.height))
      //  print("\(position) \(ref)")
            
        if(self.lastReferencePoint != ref){
          //
            print(position)
            var count:Int = 0
            var newKeys:[String] = [String]()
            var oldKeys:[String] = [String]()
            for i in Int(ref.x-self.gridSize)...Int(ref.x+self.gridSize){
                for j in Int(ref.y-self.gridSize)...Int(ref.y+self.gridSize){
                   let refPoint = "\(i),\(j)"
                    let point = CGPointMake(CGFloat(-i)*self.tileSize.width, CGFloat(-j)*self.tileSize.width)
                    
                    if(self.tileDictionary[refPoint] == nil){
                      count++
                        
                        newKeys.append(refPoint)
                        
                           let tile = TerrainTile(size: self.tileSize,position:point, elevation: 5, seaLevel: 0, segmentCount: 100)
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
                self.tileDictionary.removeValueForKey(k)
                self.delegate!.removeTile(badTile!)
            }
        
           
           // print("ref: \(ref), generating \(count) new tiles. resulting in \(self.tileDictionary.count) tiles")
            
          // print("newKeys: \(newKeys), oldKeys: \(oldKeys), count: \(count)")
            self.lastReferencePoint = ref
        }
        
        self.mutex = true
    })
    
        }
    }


}

protocol TileGeneratorDelegate{
    func placeTile(tile:TerrainTile)
    func removeTile(tile:TerrainTile)
}