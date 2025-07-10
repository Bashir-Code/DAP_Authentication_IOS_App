//
//  CSVLogger.swift
//  DAP.test
//
//  Created by Bashir on 2025/05/29.
//
// DAP.test Watch App/CSVLogger.swift

//import Foundation
//
//class CSVLogger {
//    static let shared = CSVLogger()
//    
//    private let fileName = "User01_GestureZ_Sitting_NormalSpeed_Rep05.csv"
//    
//    func save(x: Double, y: Double, z: Double, type: String = "accel") {
//        let timestamp = Date().timeIntervalSince1970
//        let row = "\(type),\(timestamp),\(x),\(y),\(z)\n"
//        appendToFile(row: row)
//    }
//
//    private func appendToFile(row: String) {
//        let url = getDocumentsDirectory().appendingPathComponent(fileName)
//        if !FileManager.default.fileExists(atPath: url.path) {
//            try? "type,timestamp,x,y,z\n".write(to: url, atomically: true, encoding: .utf8)
//        }
//        if let handle = try? FileHandle(forWritingTo: url) {
//            handle.seekToEndOfFile()
//            if let data = row.data(using: .utf8) {
//                handle.write(data)
//            }
//            handle.closeFile()
//        }
//    }
//
//    func getLogFileURL() -> URL {
//        return getDocumentsDirectory().appendingPathComponent(fileName)
//    }
//
//    private func getDocumentsDirectory() -> URL {
//        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    }
//}



import Foundation

class CSVLogger {
    static let shared = CSVLogger()
    
    private var fileName: String = ""
    private var isLogging = false
    
    /// Creates a new file with a unique name for each recording session
    func startLogging(userID: String = "User01",condition: String = "Possitive") {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = formatter.string(from: Date())
        
        // Generate a unique file name with timestamp
        fileName = "\(userID)_\(condition)_\(dateString).csv"
        
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        // Create new file with header
        do {
            try "type,timestamp,x,y,z\n".write(to: url, atomically: true, encoding: .utf8)
            print("New CSV file created: \(fileName)")
            isLogging = true
        } catch {
            print("Failed to create new file: \(error.localizedDescription)")
            isLogging = false
        }
    }
    
    /// Saves data to the current CSV file
    func save(x: Double, y: Double, z: Double, type: String = "accel") {
        guard isLogging else {
            print("Logging has not started, cannot save.")
            return
        }
        let timestamp = Date().timeIntervalSince1970
        let row = "\(type),\(timestamp),\(x),\(y),\(z)\n"
        appendToFile(row: row)
    }

    /// Appends a row to the current CSV file
    private func appendToFile(row: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile()
            if let data = row.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        } else {
            print("Failed to open file for appending.")
        }
    }

    /// Returns the URL of the current log file
    func getLogFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }

    /// Helper to get documents directory
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// Stops logging for current session
    func stopLogging() {
        isLogging = false
        print("Logging stopped for file: \(fileName)")
    }
}

