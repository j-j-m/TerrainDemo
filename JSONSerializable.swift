//
//  JSONSerializable.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/9/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation

//: ### Defining the protocols
protocol JSONRepresentable {
    var JSONRepresentation: Any { get }
}

protocol JSONSerializable: JSONRepresentable {}

//: ### Implementing the functionality through protocol extensions
extension JSONSerializable {
    var JSONRepresentation: Any {
        var representation = [String: Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
                
            case let value as Dictionary<String, Any>:
                representation[label] = value as AnyObject
                
            case let value as Array<Any>:
                if let val = value as? [JSONSerializable] {
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject }) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
                
            case let value:
                representation[label] = value as AnyObject
                
            default:
                // Ignore any unserializable properties
                break
            }
        }
        return representation as Any
    }
}

extension JSONSerializable {
    
    func toJSON() -> Data? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            print("Invalid JSON Representation")
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            
            return data
        } catch {
            return nil
        }
    }
    
    func toJSONString() -> String? {
        if let data = toJSON(){
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}
