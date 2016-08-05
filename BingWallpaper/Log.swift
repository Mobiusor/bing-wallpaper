//
//  Log.swift
//  BingWallpaper
//
//  Created by Bruno Bu on 6/1/16.
//  Copyright © 2016 Mobiusor. All rights reserved.
//

import Foundation
import LogKit

public class Log {
    public static let sharedInstance = Log()
    public let log: LXLogger
    
    private init() {
        let logFile = LXFileEndpoint(fileURL: NSURL(fileURLWithPath: Constants.logFilePath), minimumPriorityLevel: .All)
        log = LXLogger(endpoints: [LXConsoleEndpoint(), logFile])
    }
    
    private func checkAndCreateLogFile() {
        
    }
}