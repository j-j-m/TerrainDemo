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
    var tileSize:CGSize = CGSizeMake(500, 500)
    var tileDictionary:[Int:TerrainTile] = Dictionary()
    var lastReferencePoint:CGPoint = CGPointMake(0, 0)
    
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
        
        var ref:CGPoint = CGPointMake(FASTFLOOR(position.x/tileSize.width), FASTFLOOR(position.y/tileSize.height))
        if(lastReferencePoint != ref){
            var count:Int = 0
            for i in Int(ref.x-1)...Int(ref.x+1){
                for j in Int(ref.y-1)...Int(ref.y+1){
                   
                    
                    if(tileDictionary["\(CGFloat(i)*tileSize.width),\(CGFloat(j)*tileSize.width)".hashValue] == nil){
                        count++
                        let tile = TerrainTile(size: tileSize,position:CGPointMake(CGFloat(-i)*tileSize.width, CGFloat(-j)*tileSize.width), elevation: 5, seaLevel: 0, segmentCount: 100)
                        
                         tileDictionary[tile.hashValue] = tile
                        self.delegate!.placeTile(tile)
                    }
                    
                    
                    //                if(i==0 && j==0){
                    //                    self.delegate!.removeTile(tile)
                    //                }
                    
                }
            }
            print("ref: \(ref), generating \(count) new tiles.")
            lastReferencePoint = ref
            
        }
        
        
        

    }


}

protocol TileGeneratorDelegate{
    func placeTile(tile:TerrainTile)
    func removeTile(tile:TerrainTile)
}