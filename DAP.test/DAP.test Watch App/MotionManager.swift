//
//  MotionManager.swift
//  DAP.test
//
//  Created by Bashir Mohammad Abdul on 2025/04/30.
//
import Foundation
import CoreMotion
import WatchConnectivity


class MotionManager: NSObject, ObservableObject, WCSessionDelegate {
    
    private var motionManager = CMMotionManager()
    
    @Published var accelData: CMAccelerometerData?
    @Published var gyroData: CMGyroData?
    @Published var gyroX: Double = 0.0
    @Published var gyroY: Double = 0.0
    @Published var gyroZ: Double = 0.0
    @Published var isRecording: Bool = false
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    func startAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 5.0
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.accelData = data
                        print("Accel: x:\(data.acceleration.x), y:\(data.acceleration.y), z:\(data.acceleration.z)")
                        CSVLogger.shared.save(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z, type: "accel")
                    }
                }
            }
        } else {
            print("Accelerometer not available")
        }
    }
    func startGyroscope() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 5.0
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
                guard let self = self else { return }
                guard self.isRecording else { return }
                if let motion = motion {
                    let gyro = motion.rotationRate
                    DispatchQueue.main.async {
                        self.gyroX = gyro.x
                        self.gyroY = gyro.y
                        self.gyroZ = gyro.z
                        print("Gyro (via DeviceMotion): x:\(gyro.x), y:\(gyro.y), z:\(gyro.z)")
                        CSVLogger.shared.save(x: gyro.x, y: gyro.y, z: gyro.z, type: "gyro")
                    }
                } else if let error = error {
                    print("DeviceMotion Gyro error: \(error.localizedDescription)")
                }
            }
        } else {
            print("Device Motion not available")
        }
    }
    
    func stopUpdates() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
    }
    
    func startRecording() {
        isRecording = true
        // startAccelerometer()
        // startGyroscope()
        if isRecording {
            startAccelerometer()
            startGyroscope()
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        isRecording = false
        stopUpdates()
        print("Stopping recording and attempting transfer")
        transferCSVToiPhone()
    }
    
    private func transferCSVToiPhone() {
        let fileURL = CSVLogger.shared.getLogFileURL()
        if WCSession.isSupported() && WCSession.default.activationState == .activated && WCSession.default.isCompanionAppInstalled {
            WCSession.default.transferFile(fileURL, metadata: ["filename": fileURL.lastPathComponent])
            print("Transferring CSV to iPhone: \(fileURL.lastPathComponent)")
        } else {
            print("WCSession not activated or not supported")
        }
    }
    
    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated with state: \(activationState.rawValue)")
        if let error = error {
            print("WCSession activation error: \(error.localizedDescription)")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WCSession reachability changed: \(session.isReachable)")
    }
}
