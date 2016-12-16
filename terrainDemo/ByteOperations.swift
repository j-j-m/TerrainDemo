//
//  ByteOperations.swift
//  terrainDemo
//
//  Created by Jacob Martin on 12/16/16.
//  Copyright © 2016 Jacob Martin. All rights reserved.
//

import Foundation


typealias Byte = UInt8
typealias Bytes = [Byte]



extension Data {
    
    
    init<T>(fromArray values: [T], stride: Int) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }
    
    init<T>(fromArray values: [T]) {
        var values = values
        self.init(buffer: UnsafeBufferPointer(start: &values, count: values.count))
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
}
