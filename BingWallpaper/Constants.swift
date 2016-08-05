//
//  Constants.swift
//  BingWallpaper
//
//  Created by Bruno Bu on 2/3/15.
//  Copyright (c) 2015 Bruno Bu. All rights reserved.
//

import Foundation

public struct Constants {
    public static var pictureCount: Int = 1
    
    public static var pictureIndex: Int = 0
    
    public static var market: String = "zh-cn"

    public static var pictureInfoUrl: String {
        return "https://www.bing.com/hpimagearchive.aspx?format=xml&pid=hpidx=\(pictureIndex)&n=\(pictureCount)&mkt=\(market)"
    }
    
    public static var pictureUrlTemplate: String {
        return "https://www.bing.com{0}_1920x1080.jpg"
    }
    
    public static var userPath: String = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
    
    public static var imageFilePath: String = "/Users/Shared/BingWallpaper"
    
    public static var logFilePath: String = logDirectoryPath + "trace.log"
    
    public static var logDirectoryPath: String = userPath + "/Logs/BingWallpaper/"
}