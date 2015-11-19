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
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}