//
//  ext_Dictionary.swift
//  TerrainDemo
//
//  Created by Jacob Martin on 11/18/15.
//  Copyright © 2015 Jacob Martin. All rights reserved.
//


extension Dictionary {
    init(_ elements: [Element]){
        self.init()
        for (k, v) in elements {
            self[k] = v
        }
    }
    
    func map<U>(_ transform: (Value) -> U) -> [Key : U] {
        return Dictionary<Key, U>(self.map( { (key, value) in (key, transform(value)) }))
    }
    
    func map<T : Hashable, U>(_ transform: (Key, Value) -> (T, U)) -> [T : U] {
        return Dictionary<T, U>(self.map(transform))
    }
    
    func filter(_ includeElement: (Element) -> Bool) -> [Key : Value] {
        return Dictionary(self.filter(includeElement))
    }
    
    func reduce<U>(_ initial: U, combine: (U, Element) -> U) -> U {
        return self.reduce(initial, combine: combine)
    }
}
