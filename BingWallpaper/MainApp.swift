//
//  Menu.swift
//  BingWallpaper
//
//  Created by Bruno Bu on 6/1/16.
//  Copyright © 2016 Mobiusor. All rights reserved.
//

import Cocoa
import Alamofire

class MainApp: NSObject, DataFetcherDelegate {
    
    var menu: NSMenu = NSMenu()
    var statusBarItem: NSStatusItem!
    var autoStartMenuItem: NSMenuItem!
    private var dataFetcher = DataFetcher()
    private var imageInfo: WallpaperInfo? = nil
    private var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        super.init()
        dataFetcher.delegate = self
    }
    
    
    func initStatusBar() {
        //Add statusBarItem
        statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(32)
        statusBarItem.menu = menu
        statusBarItem.image = NSImage(named: "StatusIcon")
        
        //Add menuItem to menu
        let downloadMenuItem = NSMenuItem()
        downloadMenuItem.title = "Get Bing Wallpaper"
        downloadMenuItem.target = self
        downloadMenuItem.action = #selector(fetchBingWallpaper)
        menu.addItem(downloadMenuItem)
        
        let configMenuItem = NSMenuItem()
        configMenuItem.title = "Preferences..."
        configMenuItem.target = self
        configMenuItem.action = #selector(setPreference)
        menu.addItem(configMenuItem)
        
        autoStartMenuItem = NSMenuItem()
        autoStartMenuItem.title = "Enable Auto Start"
        autoStartMenuItem.target = self
        autoStartMenuItem.action = #selector(toggleAutoStart)
        if true == userDefaults.boolForKey("AutoStart") {
            autoStartMenuItem.state = NSOnState
        }
        menu.addItem(autoStartMenuItem)
        
        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "Quit"
        quitMenuItem.target = self
        quitMenuItem.action = #selector(quit)
        menu.addItem(quitMenuItem)
    }
    
    
    func startTimer() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(3600 * 3, target: self, selector: #selector(fetchBingWallpaper), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    
    // MARK: - menu item actions
    @objc @IBAction func fetchBingWallpaper(sender: AnyObject) {
        Log.sharedInstance.log.info("check if new bing wallpaper updated")
        dataFetcher.fetchWallpaperInfoAsync()
    }
    
    @objc func toggleAutoStart(sender: AnyObject) {
        var autoStart = userDefaults.boolForKey("AutoStart")
        autoStart = !autoStart
        if autoStart == true {
            autoStartMenuItem.state = NSOnState
        } else {
            autoStartMenuItem.state = NSOffState
        }
        userDefaults.setBool(autoStart, forKey: "AutoStart")
    }
    
    func about(sender: AnyObject) {
        
    }
    
    @objc func setPreference(sender: AnyObject) {

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("preferenceWindowController") as? NSWindowController
        if let window = windowController?.window{
            let application = NSApplication.sharedApplication()
            application.runModalForWindow(window)
        }
    }
    
    @objc func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
}


// MARK: - implement DataFetcherDelegate
extension MainApp {
    func imageFetched(image: NSImage) {
        let imgRep = image.representations[0] as! NSBitmapImageRep
        let imgData = imgRep.representationUsingType(NSBitmapImageFileType.NSJPEGFileType, properties: ["name":"Bruno"])
        
        // save to file
        let directory = userDefaults.stringForKey("WallpaperPath") ?? Constants.imageFilePath
        let filePath = directory + "/Desktop-\(imageInfo!.startDate).jpg"
        
        
        imgData!.writeToFile(filePath, atomically: false)
        Log.sharedInstance.log.info("image saved to local file: \(filePath)")
        
        // set wallpaper
        let storeUrl = NSURL(fileURLWithPath: filePath)
        let curScreen = NSScreen.mainScreen()
        let screenOptions = NSWorkspace.sharedWorkspace().desktopImageOptionsForScreen(curScreen!)
        do {
            try NSWorkspace.sharedWorkspace().setDesktopImageURL(storeUrl, forScreen: curScreen!, options: screenOptions!)
        } catch _ {
        }
        Log.sharedInstance.log.info("image setted: \(filePath)")
    }
    
    func imageInfoFetched(info: WallpaperInfo) {
        imageInfo = info
        let lastImageUrl = userDefaults.stringForKey("lastImageUrl")
        if lastImageUrl == info.url {
            return
        }
        userDefaults.setObject(info.url, forKey: "lastImageUrl")
        Log.sharedInstance.log.info("start fetching new image")
        dataFetcher.fetchWallpaperAsync(info)
    }
}
