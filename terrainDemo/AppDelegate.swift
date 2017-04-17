//
//  AppDelegate.swift
//  terrainDemo
//
//  Created by Jacob Martin on 11/16/15.
//  Copyright (c) 2015 Jacob Martin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        DispatchQueue.global().async {

            try! GamePadServer.shared.start()
            print("Swift Echo Server Sample")
            print("Connect with a command line window by entering 'telnet 127.0.0.1 \(1337)'")
            
       
        }
    }
    
}


