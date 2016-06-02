//
//  AppDelegate.swift
//  BingWallpaper
//
//  Created by Bruno Bu on 6/1/16.
//  Copyright © 2016 Mobiusor. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var app: MainApp = MainApp()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        app.initStatusBar()
        app.startTimer()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

