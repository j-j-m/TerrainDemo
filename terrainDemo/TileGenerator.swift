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
    var tileSize:CGSize = CGSizeMake(1000, 1000)
    var tileDictionary:[Int:TerrainTile] = Dictionary()
    var lastReferencePoint:CGPoint = CGPointMake(0, 0)
    var mutex:Bool = true
    override init(){
        super.init()
    }
    
    init(position:CGPoint, delegate:TileGeneratorDelegate){
        self.delegate = delegate
        super.init()
        
        for i in -3...3{
            for j in -3...3{
            var tile = TerrainTile(size: tileSize,position:CGPointMake(CGFloat(i)*tileSize.width, CGFloat(j)*tileSize.width), elevation: 5, seaLevel: 0, segmentCount: 100)
                
            tileDictionary[tile.hashValue] = tile
            self.delegate!.placeTile(tile)
                
//                if(i==0 && j==0){
//                    self.delegate!.removeTile(tile)
//                }
                
            }
        }
        
        print(tileDictionary)
    }
    
    func generateTilesForPosition(position:SCNVector3){
        
        if(mutex){
        self.mutex=false
        let qualityOfServiceClass = QOS_CLASS_USER_INTERACTIVE
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
        
        var ref:CGPoint = CGPointMake(FASTFLOOR(position.x/self.tileSize.width), FASTFLOOR(position.y/self.tileSize.height))
        if(self.lastReferencePoint != ref){
            var count:Int = 0
            for i in Int(ref.x-2)...Int(ref.x+2){
                for j in Int(ref.y-2)...Int(ref.y+2){
                   
                    
                    if(self.tileDictionary["\(CGFloat(i)*self.tileSize.width),\(CGFloat(j)*self.tileSize.width)".hashValue] == nil){
                        count++
                        
                        
                           let tile = TerrainTile(size: self.tileSize,position:CGPointMake(CGFloat(-i)*self.tileSize.width, CGFloat(-j)*self.tileSize.width), elevation: 5, seaLevel: 0, segmentCount: 100)
                            self.tileDictionary[tile.hashValue] = tile
                            self.delegate!.placeTile(tile)
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                self.tileDictionary[tile.hashValue] = tile
//                                self.delegate!.placeTile(tile)
//                            })
                        
                        
                        
                        
                        
                    }
                    
                    
                    //                if(i==0 && j==0){
                    //                    self.delegate!.removeTile(tile)
                    //                }
                    
                }
            }
            print("ref: \(ref), generating \(count) new tiles.")
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