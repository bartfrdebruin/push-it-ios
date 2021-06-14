//
//  OSLog.swift
//  Push it
//
//  Created by Bart on 11/06/2021.
//

import os.log
import Foundation

extension OSLog {
    
    // swiftlint:disable force_unwrapping
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let backgroundForgroundLog = OSLog(subsystem: subsystem, category: "BackgroundForground")

    /// Write a message in the local device log/console and on crashlytics if remote is true
    /// - Parameters:
    ///   - msg: The message to log
    ///   - osLog: The category to be used
    ///   - remote: True if the log needs to be written on crashlytics
    static func logMsg(_ msg: String, osLog: OSLog = .default) {
        
        os_log("%{public}@", log: OSLog.backgroundForgroundLog, type: .info, msg)
    }
}
