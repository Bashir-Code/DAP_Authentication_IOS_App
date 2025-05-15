//
//  ContentView.swift
//  DAPiOSApp
//
//  Created by 金杰 on 2025/05/29.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var mpManager = MultipeerManager()
    @State private var messageToSend = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Received: \(mpManager.receivedString)")
                .padding()

            TextField("Enter message", text: $messageToSend)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("Start Hosting") {
                    mpManager.startHosting()
                }
                Button("Join Session") {
                    mpManager.joinSession()
                }
            }
            .padding()

            Button("Send") {
                mpManager.send(messageToSend)
                messageToSend = ""
            }
            .padding()
        }
        .padding()
    }
}
