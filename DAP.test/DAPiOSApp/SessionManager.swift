import Foundation
import WatchConnectivity

class SessionManager: NSObject, WCSessionDelegate {
    static let shared = SessionManager()
    private let session = WCSession.default

    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let type = message["type"] as? String,
           let timestamp = message["timestamp"] as? TimeInterval,
           let x = message["x"] as? Double,
           let y = message["y"] as? Double,
           let z = message["z"] as? Double {
            let line = "\(type),\(timestamp),\(x),\(y),\(z)\n"
            appendToCSV(line: line)
        }
    }

    private func appendToCSV(line: String) {
        let fileManager = FileManager.default
        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docsURL.appendingPathComponent("motion_data.csv")

        if !fileManager.fileExists(atPath: fileURL.path) {
            let header = "type,timestamp,x,y,z\n"
            try? header.write(to: fileURL, atomically: true, encoding: .utf8)
        }

        if let handle = try? FileHandle(forWritingTo: fileURL) {
            handle.seekToEndOfFile()
            if let data = line.data(using: .utf8) {
                handle.write(data)
            }
            handle.closeFile()
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) { session.activate() }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
