//
//  GamePadServer.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/9/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation
import Socket
import Dispatch
import CoreGraphics

protocol GamePadServerDelegate {
   func gamepadXYLeft(_ x: Float, _ y: Float)
   func gamepadXYRight(_ x: Float, _ y: Float)
}

class GamePadServer {

    static let shared: GamePadServer = GamePadServer()

    let bufferSize = 1024
    let port: Int = 1337
    var listenSocket: Socket? = nil
    var connected = [Int32: Socket]()
    var acceptNewConnection = true
    
    var delegate: GamePadServerDelegate?
    
    private init() {
        
    }
    
    deinit {
        for socket in connected.values {
            socket.close()
        }
        listenSocket?.close()
    }
    
    func start() throws {
        let socket = try Socket.create()
        
        listenSocket = socket
        try socket.listen(on: port)
        print("Listening port: \(socket.listeningPort)")
        let queue = DispatchQueue(label: "clientQueue.gamePad", attributes: .concurrent)
        repeat {
            let connectedSocket = try socket.acceptClientConnection()
            print("Connection from: \(connectedSocket.remoteHostname)")
            queue.async{self.newConnection(socket: connectedSocket)}
        } while acceptNewConnection
    }
    
    func newConnection(socket: Socket) {
        connected[socket.socketfd] = socket
        
        var cont = true
        var dataRead = Data(capacity: bufferSize)
        repeat {
            do {
                let bytes = try socket.read(into: &dataRead)
                if bytes > 0 {
                    
                    
                    if let readStr = String(data: dataRead, encoding: .utf8) {
                        processDataString(readStr)
                       // print("Received: \(readStr)")
                        try socket.write(from: readStr)
                        if readStr.hasPrefix("quit") {
                            cont = false
                            socket.close()
                        }
                        dataRead.count = 0
                    }
                }
            } catch let error {
                print("error: \(error)")
            }
        } while cont
        connected.removeValue(forKey: socket.socketfd)
        socket.close()
    }
    
    func processDataString(_ string:String){
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
            let obj:AnyObject? = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? AnyObject
                if let type = obj!["type"] as? String {
                    switch type {
                        case "XYL":
                            let x = obj!["x"] as! Float
                            let y = obj!["y"] as! Float
                            delegate?.gamepadXYLeft(x,y)
                        case "XYR":
                            let x = obj!["x"] as! Float
                            let y = obj!["y"] as! Float
                            delegate?.gamepadXYRight(x,y)
                    default:
                        break
                    }
                }
            }
            catch {
                print("bad data")
                
            }
        } else {
           
           print("bad data")
        }
    }
}
