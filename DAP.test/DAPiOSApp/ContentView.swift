//
//  ContentView.swift
//  DAPiOSApp
//
//  Created by Bashir on 2025/07/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("DAPiOSApp")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Image(systemName: "waveform.path.ecg")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)

            Text("Ready to collect motion data from your Apple Watch.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
