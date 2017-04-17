//
//  SocketClient.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/9/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//
import Socket
import Foundation

final class SocketClient {
    
    //MARK: Shared Instance
    
    static let shared: SocketClient = SocketClient()
    
    //MARK: Local Variable
    
    let bufferSize = 1024
    let port: Int = 1337
    let server: String = "10.0.1.36"
    var socket: Socket? = nil

    
    private init() {
       try! start()
    }
    
    deinit {
        socket?.close()
    }
    
    func send(_ obj: Data){
        
        try! socket?.write(from: obj)
    }
    
    func start() throws {
        socket = try Socket.create()
        
        try socket?.connect(to: server, port: Int32(port))
        var dataRead = Data(capacity: bufferSize)
//        var cont = true
//        repeat {
//            print("Enter Text:")
//            if let entered = readLine(strippingNewline: true) {
//                try socket.write(from: entered)
//                if entered.hasPrefix("quit") {
//                    cont = false
//                }
//                let bytesRead = try socket.read(into: &dataRead)
//                if bytesRead > 0 {
//                    if let readStr = String(data: dataRead, encoding: .utf8) {
//                        print("Received: '\(readStr)'")
//                    }
//                    dataRead.count = 0
//                }
//            }
//        } while cont
    }
    
}
