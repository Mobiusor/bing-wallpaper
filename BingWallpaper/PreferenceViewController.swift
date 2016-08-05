//
//  PreferenceViewController.swift
//  BingWallpaper
//
//  Created by Bruno Bu on 6/2/16.
//  Copyright © 2016 Mobiusor. All rights reserved.
//

import Cocoa

enum CheckTime: Int {
    case OneDay = 0
    case ThreeHours = 1
    case OneHour = 2
    
    var timeInterval: NSTimeInterval {
        switch self {
        case .OneHour: return 3600
        case .ThreeHours: return 3600 * 3
        case .OneDay: return 3600 * 24
        }
    }
}

class PreferenceViewController: NSViewController {

    @IBOutlet weak var textFilePath: NSTextField!
    @IBOutlet weak var popUpButton: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFilePath.stringValue = NSUserDefaults.standardUserDefaults().stringForKey("WallpaperPath") ?? ""
        // Do view setup here.
        
        let checkTimeInt = NSUserDefaults.standardUserDefaults().integerForKey("checkTime") ?? CheckTime.ThreeHours.rawValue
        popUpButton.selectItemAtIndex(checkTimeInt)
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
    
    @IBAction func openImageFolder(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: Constants.imageFilePath)
    }
    
    @IBAction func openLogFile(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: Constants.logDirectoryPath)
    }
    
    @IBAction func selectCheckTime_1Day(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(CheckTime.OneDay.rawValue, forKey: "checkTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func selectCheckTime_3Hours(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(CheckTime.ThreeHours.rawValue, forKey: "checkTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func selectCheckTime_1Hour(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(CheckTime.OneHour.rawValue, forKey: "checkTime")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
