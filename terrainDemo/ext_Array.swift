//
//  ext_Array.swift
//  TerrainDemo
//
//  Created by Jacob Martin on 11/18/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//

import Foundation


// Swift 2 Array Extension
extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
