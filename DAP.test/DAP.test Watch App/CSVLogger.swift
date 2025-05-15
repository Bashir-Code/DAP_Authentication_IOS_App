//
//  CSVLogger.swift
//  DAP.test
//
//  Created by 金杰 on 2025/05/29.
//

// DAP.test Watch App/CSVLogger.swift
import Foundation

class CSVLogger {
    static let shared = CSVLogger()
    
    private let fileName = "motion_log.csv"
    
    func save(x: Double, y: Double, z: Double, type: String = "accel") {
        let timestamp = Date().timeIntervalSince1970
        let row = "\(type),\(timestamp),\(x),\(y),\(z)\n"
        appendToFile(row: row)
    }

    private func appendToFile(row: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? "type,timestamp,x,y,z\n".write(to: url, atomically: true, encoding: .utf8)
        }
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile()
            if let data = row.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        }
    }

    func getLogFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
