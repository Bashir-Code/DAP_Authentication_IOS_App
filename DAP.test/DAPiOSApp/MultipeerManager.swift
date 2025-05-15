//
//  MultipeerManager.swift
//  DAP.test
//
//  Created by Bashir Mohammad Abdul on 2025/06/05.
//

import Foundation
import MultipeerConnectivity

class MultipeerManager: NSObject, ObservableObject {
    private let serviceType = "motion-data"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let session: MCSession
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    @Published var receivedString: String = ""
    
    override init() {
        self.session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
    }
    
    func startHosting() {
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func joinSession() {
        serviceBrowser.startBrowsingForPeers()
    }
    
    func send(_ string: String) {
        if !session.connectedPeers.isEmpty {
            if let data = string.data(using: .utf8) {
                do {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    print("Error sending data: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Extensions for Delegate Methods
extension MultipeerManager: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    // MCSessionDelegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Peer \(peerID.displayName) changed state: \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.receivedString = string
            }
        }
    }
    
    // These required methods can be empty if unused:
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }

    // Advertiser
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                     withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    // Browser
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
    }
}
