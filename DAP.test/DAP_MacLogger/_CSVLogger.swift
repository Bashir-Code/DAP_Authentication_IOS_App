//
//  CSVLogger.swift
//  DAP.test
//
//  Created by Bashir Mohammad Abdul on 2025/05/13.
//

//import Foundation
//
//class CSVLogger {
//    let fileName = "MotionData.csv"
//    var fileURL: URL
//
//    init() {
//        let desktopDir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//        let folder = desktopDir.appendingPathComponent("Experiment/DAP_Authentication", isDirectory: true)
//        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
//
//        fileURL = folder.appendingPathComponent(fileName)
//
//        if !FileManager.default.fileExists(atPath: fileURL.path) {
//            let headers = "timestamp,x,y,z\n"
//            try? headers.write(to: fileURL, atomically: true, encoding: .utf8)
//        }
//    }
//
//    func appendLine(_ line: String) {
//        guard let data = line.data(using: .utf8),
//              let fileHandle = try? FileHandle(forWritingTo: fileURL) else {
//            print("Could not open file.")
//            return
//        }
//
//        fileHandle.seekToEndOfFile()
//        fileHandle.write(data)
//        fileHandle.closeFile()
//    }
//}
