//
//  PreferenceViewController.swift
//  BingWallpaper
//
//  Created by Bruno Bu on 6/2/16.
//  Copyright © 2016 Mobiusor. All rights reserved.
//

import Cocoa

class PreferenceViewController: NSViewController {

    @IBOutlet weak var textFilePath: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFilePath.stringValue = NSUserDefaults.standardUserDefaults().stringForKey("WallpaperPath") ?? ""
        // Do view setup here.
    }
    
    @IBAction func dismissPreferenceWindow(sender: NSButton) {
        let application = NSApplication.sharedApplication()
        application.stopModal()
    }
    
    @IBAction func chooseFile(sender: NSButton) {
        let fileDialog: NSOpenPanel = NSOpenPanel()
        fileDialog.canChooseDirectories = true
        fileDialog.runModal()

        if let path = fileDialog.URL?.path {
            NSUserDefaults.standardUserDefaults().setObject(path, forKey: "WallpaperPath")
            textFilePath.stringValue = path
        }
    }
    
}
