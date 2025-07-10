//
//  ContentView.swift
//  DAP.test Watch App
//
//  Created by Bashir Mohammad Abdul on 2025/04/28.
//
//import SwiftUI
//struct ContentView: View {
//    @StateObject private var motionManager = MotionManager()
//    var body: some View {
//        VStack {
//            Text("Accelerometer")
//            Text("X: \(motionManager.accelData?.acceleration.x ?? 0, specifier: "%.2f")")
//            Text("Y: \(motionManager.accelData?.acceleration.y ?? 0, specifier: "%.2f")")
//            Text("Z: \(motionManager.accelData?.acceleration.z ?? 0, specifier: "%.2f")")
//            Text("Gyroscope")
//            Text("X: \(motionManager.gyroX, specifier: "%.2f")")
//            Text("Y: \(motionManager.gyroY, specifier: "%.2f")")
//            Text("Z: \(motionManager.gyroZ, specifier: "%.2f")")
//            Button(action: {
//                if motionManager.isRecording {
//                    motionManager.stopRecording()
//                } else {
//                    motionManager.startRecording()
//                }
//            }) {
//                Text(motionManager.isRecording ? "Stop Recording" : "Start Recording")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(motionManager.isRecording ? Color.red : Color.green)
//                    .cornerRadius(10)
//            }
//        }
//        .padding()
//    }
//}


//
//  ContentView.swift
//  DAP.test Watch App
//
//  Created by Bashir Mohammad Abdul on 2025/04/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack {
            Text("Accelerometer")
            Text("X: \(motionManager.accelData?.acceleration.x ?? 0, specifier: "%.2f")")
            Text("Y: \(motionManager.accelData?.acceleration.y ?? 0, specifier: "%.2f")")
            Text("Z: \(motionManager.accelData?.acceleration.z ?? 0, specifier: "%.2f")")
            
            Text("Gyroscope")
            Text("X: \(motionManager.gyroX, specifier: "%.2f")")
            Text("Y: \(motionManager.gyroY, specifier: "%.2f")")
            Text("Z: \(motionManager.gyroZ, specifier: "%.2f")")
            
            Button(action: {
                if motionManager.isRecording {
                    motionManager.stopRecording()
                    CSVLogger.shared.stopLogging()
                } else {
                    // Start a new CSV file before recording
                    CSVLogger.shared.startLogging()
                    motionManager.startRecording()
                }
            }) {
                Text(motionManager.isRecording ? "Stop Recording" : "Start Recording")
                    .foregroundColor(.white)
                    .padding()
                    .background(motionManager.isRecording ? Color.red : Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
