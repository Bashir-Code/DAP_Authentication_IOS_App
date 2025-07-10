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

    // Send file to iPhone
    func sendCSVToiPhone() {
        let fileURL = CSVLogger.shared.getLogFileURL()
        if WCSession.default.isReachable {
            WCSession.default.transferFile(fileURL, metadata: ["filename": "motion_log.csv"])
            print("Sent CSV to iPhone")
        } else {
            print("iPhone not reachable")
        }
    }

    // Required WCSessionDelegate stubs
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionReachabilityDidChange(_ session: WCSession) {}
}
