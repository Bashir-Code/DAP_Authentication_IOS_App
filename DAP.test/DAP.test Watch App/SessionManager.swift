//
//  SessionManager.swift
//  DAP.test
//
//  Created by Bashir Mohammad Abdul on 2025/07/03.
//

//import WatchConnectivity
//
//class SessionManager: NSObject, WCSessionDelegate, ObservableObject {
//    static let shared = SessionManager()
//    
//    private override init() {
//        super.init()
//        activateSession()
//    }
//
//    private func activateSession() {
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//    }
//    
//    // Send file to iPhone
//    func sendCSVToiPhone() {
//        let fileURL = CSVLogger.shared.getLogFileURL()
//        if WCSession.default.isReachable {
//            WCSession.default.transferFile(fileURL, metadata: ["filename": "motion_log.csv"])
//            print("Sent CSV to iPhone")
//        } else {
//            print("iPhone not reachable")
//        }
//    }
//
//    // Required WCSessionDelegate stubs
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
//    func sessionReachabilityDidChange(_ session: WCSession) {}
//}


import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = SessionManager()
    
    private override init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // Send CSV file to iPhone
    func sendCSVToiPhone() {
        let fileURL = CSVLogger.shared.getLogFileURL()
        var isDir: ObjCBool = false
        
        if FileManager.default.fileExists(atPath: fileURL.path, isDirectory: &isDir) {
            if isDir.boolValue {
                print("Error: fileURL points to a directory, not a file.")
                return
            }
            
            if WCSession.default.isReachable {
                print("iPhone reachable. Sending file: \(fileURL.lastPathComponent)")
                WCSession.default.transferFile(fileURL, metadata: ["filename": fileURL.lastPathComponent])
            } else {
                print("iPhone not reachable for file transfer.")
            }
        } else {
            print("File does not exist at path: \(fileURL.path)")
        }
    }

    // Required WCSessionDelegate stubs
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
}


