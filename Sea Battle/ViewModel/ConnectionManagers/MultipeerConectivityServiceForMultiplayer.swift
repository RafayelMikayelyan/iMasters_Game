//
//  MultipeerConectivityServiceForMultiplayer.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//  MPC will not work over Bluetooth on iOS 11+, it works by connecting to the same network

import MultipeerConnectivity

protocol PeerIDRecieverDelegate: AnyObject {
    func getPeerId(_ sender: MultiplayerConectionAsMPCHandler,peerId: MCPeerID,discoveryInfo: [String:String]?, with type: DataType)
    func setConnectionState(_ sender: MultiplayerConectionAsMPCHandler,for index: IndexPath, with state: ConnectingState)
}

@objc protocol TimerResponder {
    @objc func timerResponderSelector(_ sender: Timer)
}

extension MultiplayerConectionAsMPCHandler: NetworkConnectionCheckerManagerDelegate {
    func provideStatus(_sender: NetworkConnectionCheckerManager, status: ConnectionStatus) {
        self.givenNetworkConnectionStatus = status
        if self.givenNetworkConnectionStatus == .connected {
            self.delegate?.setConnectionState(self, for: self.inviterIndexPath, with: .canceled)
        } else {
            self.delegate?.setConnectionState(self, for: self.inviterIndexPath, with: .networkMissing)
        }
    }

}

final class MultiplayerConectionAsMPCHandler: NSObject {
    
    var functionlaityWhenConnectionInviteProvided: (PlayerContextualData) -> Void = {_ in }
    var functionalityWhenConnectionEstablished: (SeaBattlePlayer) -> Void = {_ in }
    
    private let multipeerServiceType: String = "Multiplayer"
    private(set) var multiplayerSession: MCSession!
    private let playerPeerId: MCPeerID!
    private let advertiserForBroadcasting: MCNearbyServiceAdvertiser!
    private(set) var browserForConnect: MCNearbyServiceBrowser!
    private(set) var group = DispatchGroup()
    private var canConnect: Bool?
    private var networkMonitor: NetworkConnectionCheckerManager = NetworkConnectionCheckerManager()
    private var givenNetworkConnectionStatus: ConnectionStatus = .notConnected
    private var inviterIndexPath: IndexPath! = nil
    weak var delegate:PeerIDRecieverDelegate?
    weak var timerTarget: TimerResponder?

    init(displayName: String) {
        self.playerPeerId = MCPeerID(displayName: displayName)
        self.multiplayerSession = MCSession(peer: self.playerPeerId, securityIdentity: nil, encryptionPreference: .required)
        self.advertiserForBroadcasting = MCNearbyServiceAdvertiser(peer: self.playerPeerId, discoveryInfo: ["gender":DataAboutPlayerSingleton.shared.providePlayerGender()], serviceType: self.multipeerServiceType)
        self.browserForConnect = MCNearbyServiceBrowser(peer: self.playerPeerId, serviceType: self.multipeerServiceType)
        AdvertiserSessionsCloser.shared.addAdvertiserAssintent(with: self.advertiserForBroadcasting)
    }
    
    func addAdvertiserToCloder() {
        AdvertiserSessionsCloser.shared.addAdvertiserAssintent(with: self.advertiserForBroadcasting)
    }
    
    func setUpDelegates() {
        self.multiplayerSession.delegate = self
        self.advertiserForBroadcasting.delegate = self
        self.browserForConnect.delegate = self
    }
    
    func startAdvertising() {
        self.advertiserForBroadcasting.startAdvertisingPeer()
    }
    
//    func stopAdvertising() {
//        self.advertiserForBroadcasting.stopAdvertisingPeer()
//    }
    
    func startBrowsing() {
        self.browserForConnect.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        self.browserForConnect.stopBrowsingForPeers()
    }
    
//    func resetBrowser() {
//        self.browserForConnect = nil
//    }
    
    func setConnectionBarier(with barier: Bool) {
        self.canConnect = barier
    }
    
    func setInviterIndex(with indexPath: IndexPath) {
        self.inviterIndexPath = indexPath
    }
    
    func provideCannectionBarier() -> Bool? {
        return self.canConnect
    }
    
    func changeSessionDelegate(to delegate: MCSessionDelegate) {
        self.multiplayerSession.delegate = delegate
    }
    
    func changeBrowserDelegate(to delegate: MCNearbyServiceBrowserDelegate) {
        self.browserForConnect.delegate = delegate
    }
    
    func changeAdvertiserDelegate(to delegate: MCNearbyServiceAdvertiserDelegate) {
        self.advertiserForBroadcasting.delegate = delegate
    }
    
}

extension MultiplayerConectionAsMPCHandler: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            self.delegate?.setConnectionState(self, for: self.inviterIndexPath, with: .connected)
            let json = try? JSONEncoder().encode(DataAboutPlayerSingleton.shared.providePlayer())
            guard let json else {return}
            try? self.multiplayerSession.send(json, toPeers: self.multiplayerSession.connectedPeers, with: .reliable)
        }
        
        if state == .notConnected {
            self.networkMonitor = NetworkConnectionCheckerManager()
            self.networkMonitor.delegate = self
            self.networkMonitor.provideConnectionStatus()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dataDecoded = try? JSONDecoder().decode(SeaBattlePlayer.self, from: data)
        guard let dataDecoded else {return}
        functionalityWhenConnectionEstablished(dataDecoded)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //
    }
    
}

extension MultiplayerConectionAsMPCHandler: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if let target = self.timerTarget {
            _ = Timer.scheduledTimer(timeInterval: 30, target: target, selector:#selector(self.timerTarget?.timerResponderSelector) , userInfo: nil, repeats: false)
        }
        guard let context, let decodedData = try? JSONDecoder().decode(PlayerContextualData.self, from: context) else {return}
        self.functionlaityWhenConnectionInviteProvided(decodedData)
        self.group.notify(queue: DispatchQueue.global(qos: .userInteractive)) {
            invitationHandler(self.canConnect!,self.multiplayerSession)
        }
    }
}

extension MultiplayerConectionAsMPCHandler: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        self.delegate?.getPeerId(self, peerId: peerID,discoveryInfo: info, with: .get)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.delegate?.getPeerId(self, peerId: peerID, discoveryInfo: nil, with: .lost)
    }
 
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        
    }
}

