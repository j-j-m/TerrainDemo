//
//  ConnectionManager.swift
//  terrainDemo
//
//  Created by Jacob Martin on 4/9/17.
//  Copyright © 2017 Jacob Martin. All rights reserved.
//

import Foundation
import PeerKit
import MultipeerConnectivity


protocol MPCSerializable {
    var mpcSerialized: NSData { get }
    init(mpcSerialized: NSData)
}

enum Event: String {
    case Rotation, XY, WeaponL, WeaponR
}

struct ConnectionManager {
    
    // MARK: Properties
    private static var peers: [MCPeerID] {
        return PeerKit.session?.connectedPeers as [MCPeerID]? ?? []
    }
    
//    static var otherPlayers: [Player] {
//        return peers.map { Player(peer: $0) }
//    }
//    
//    static var allPlayers: [Player] { return [Player.getMe()] + otherPlayers }
    
    // MARK: Start
    static func start() {
        PeerKit.transceive(serviceType: "Game")
    }
    
    // MARK: Event Handling
    static func onConnect(run: PeerBlock?) {
        PeerKit.onConnect = run
    }
    
    static func onDisconnect(run: PeerBlock?) {
        PeerKit.onDisconnect = run
        
    }
    
    static func onEvent(event: Event, run: ObjectBlock?) {
        if let run = run {
            PeerKit.eventBlocks[event.rawValue] = run
        } else {
            PeerKit.eventBlocks.removeValue(forKey: event.rawValue)
        }
    }
    
    // MARK: Sending
    static func sendEvent(event: Event, object: [String: Any]? = nil, toPeers peers: [MCPeerID]? = PeerKit.session?.connectedPeers as [MCPeerID]?) {
        
        PeerKit.sendEvent(event.rawValue, object: object as AnyObject?, toPeers: peers)
    }
    
    static func sendEventForEach(event: Event, objectBlock: @noescape () -> ([String: MPCSerializable])) {
        for peer in ConnectionManager.peers {
            ConnectionManager.sendEvent(event: event, object: objectBlock(), toPeers: [peer])
        }
    }
}
