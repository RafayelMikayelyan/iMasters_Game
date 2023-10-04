//
//  ViewModelForBattleViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//

import Foundation
import MultipeerConnectivity

enum PlayingStatus: Codable {
    case canPlay
    case canNotPlay
}

enum ConnectorStatus {
    case starter
    case joiner
}

extension ViewModelForBattleViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // There will be implementation that scenarios when one of players kill or go to background in time connected game by session state changing
        if state == .connected {
            print("Connected")
        }
        if state == .connecting {
            print("Connecting")
        }
        if state == .notConnected {
            //MARK: - Remamber that its require any tyme to disconnect so the timer to waiting add when you enshure that session pass to disconnected state
            print("Disconnected")
            if self.connectorStatus == .starter {
                self.multipeerConectivityHandler.browserForConnect.startBrowsingForPeers()
            }
            if self.connectorStatus == .joiner {
                //MARK: - Its allready is handled by Apple Thank YOU Apple
                //nw_socket_handle_socket_event
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let decodedData = try? JSONDecoder().decode(HitInfo.self, from: data) {
            self.handleHitSelfMap(by: decodedData)
        }
        if let decodedData = try? JSONDecoder().decode(HitResponse.self, from: data) {
            self.playingStatus = decodedData.playingStatus
        }
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

extension ViewModelForBattleViewController: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
       print("Found")
        if self.connecedToPeer.count == 1 {
            print("peerIdConnected")
            if peerID == self.connecedToPeer.first! {
                self.multipeerConectivityHandler.browserForConnect.invitePeer(peerID, to: self.multipeerConectivityHandler.multiplayerSession, withContext: nil, timeout: 30)
                self.multipeerConectivityHandler.browserForConnect.stopBrowsingForPeers()
                print("peerIdConnected")
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost")
    }
}

extension ViewModelForBattleViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if self.connecedToPeer.count == 1 {
            print("peerIdConnected")
            if peerID == self.connecedToPeer.first! {// That equality works great!!!!!
                invitationHandler(true,self.multipeerConectivityHandler.multiplayerSession)
                print("ConnectionReloaded")
            }
        }
    }
}

final class ViewModelForBattleViewController: NSObject {
    
    private var multipeerConectivityHandler: MultiplayerConectionAsMPCHandler! = nil {
        didSet {
            self.connecedToPeer = self.multipeerConectivityHandler.multiplayerSession.connectedPeers
        }
    }
    private var opponentPlayer: SeaBattlePlayer
    private var connectorStatus: ConnectorStatus
    private var connecedToPeer: [MCPeerID]! = nil
    private var isStartPoint: Bool = true
    private var hittedShipsCount: Int = 0
    private(set) var group = DispatchGroup()
    private var playingStatus: PlayingStatus! = nil {
        didSet {
            if self.playingStatus == .canPlay {
                self.secondsRemained = 30
                self.setTimer()
            } else {
                self.timerForPlayerAction?.invalidate()
                self.timerForPlayerAction?.fire()
                self.timerForPlayerAction = nil
            }
            functionalityWhenPlayingStatusChanged()
        }
    }
    private(set) var providedDataForSelfMapSection: [String] = [String]() {
        didSet{
            if self.isStartPoint {
                functionalityWhenDataForSelfMapProvided()
            }
        }
    }
    
    private(set) var providedDataForOpponentMapSection: [String] = [String]() {
        didSet{
            functionalityWhenDataForOpponentMapProvided()
        }
    }
    
    private(set) var secondsRemained: Int = 30 {
        didSet {
            functionalityWhenTimerUpdates()
        }
    }
    
    private var dataModel: DataSourceForBattleViewController
    
    private var timerForPlayerAction: Timer! = nil
    
    init(dataModel: DataSourceForBattleViewController, opponentPlayer: SeaBattlePlayer,connectorStatus: ConnectorStatus) {
        self.dataModel = dataModel
        self.opponentPlayer = opponentPlayer
        self.connectorStatus = connectorStatus
    }
    
    var functionalityWhenPlayingStatusChanged: () -> Void = {}
    var functionalityWhenTimerUpdates: () -> Void = {}
    var functionalityWhenDataForSelfMapProvided : () -> Void = {}
    var functionalityWhenDataForOpponentMapProvided : () -> Void = {}
    var functionalityOnHit: () -> Void = {}
    
    func getDataForSelfMap() {
        self.providedDataForSelfMapSection = self.dataModel.provideDataForSelfMapSection()
    }

    func getDataForOpponentMap() {
        self.providedDataForOpponentMapSection = self.dataModel.provideDataForOpponentMapSection()
    }
    
    func setMultipeerConnectivityHandler(with handler: MultiplayerConectionAsMPCHandler) {
        self.multipeerConectivityHandler = handler
        self.multipeerConectivityHandler.changeSessionDelegate(to: self)
        self.multipeerConectivityHandler.changeBrowserDelegate(to: self)
        self.multipeerConectivityHandler.changeAdvertiserDelegate(to: self)
//        if self.connectorStatus == .starter {
//            self.multipeerConectivityHandler.startAdvertising()
//        }
        self.multipeerConectivityHandler.addAdvertiserToCloder()
    }
    
    func setPlayingStatus(with status: PlayingStatus) {
        self.playingStatus = status
    }
    
    func providePlayingStatus() -> PlayingStatus {
        return self.playingStatus
    }
    
    func setTimer() {
        self.timerForPlayerAction = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdateSelector), userInfo: nil, repeats: false)
    }
    
    func provideOpponentName() -> String {
        return self.opponentPlayer.playerName
    }
    
    func provideOpponentIcon() -> Data {
        return self.opponentPlayer.playerIconDescription
    }
    
    func handleHitOnopponentMap(on indexPath: IndexPath) {
        self.playingStatus = .canNotPlay
        if let segment = MapCellContainedSegment(rawValue: self.opponentPlayer.mapData[indexPath.item]) {
            guard let json = try? JSONEncoder().encode(HitInfo(hitIndexPath: indexPath)) else {return}
            self.providedDataForOpponentMapSection[indexPath.item] = "mappCelllRedHitted"
            try? self.multipeerConectivityHandler.multiplayerSession.send(json, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
            self.makeDestroyedShipIfItPossible(with: segment, on: indexPath)
        } else {
            if self.opponentPlayer.mapData[indexPath.item] == "mappCelll" {
                guard let json = try? JSONEncoder().encode(HitInfo(hitIndexPath: indexPath)) else {return}
                self.providedDataForOpponentMapSection[indexPath.item] = "mappCelllMineShadow"
                try? self.multipeerConectivityHandler.multiplayerSession.send(json, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
            }
        }
    }
    
    func handleHitSelfMap(by info: HitInfo) {
        self.isStartPoint = false
        if let _ = MapCellContainedSegment(rawValue: self.providedDataForSelfMapSection[info.hitIndexPath.item]) {
            self.providedDataForSelfMapSection[info.hitIndexPath.item] += "Hitted"
            self.playingStatus = .canNotPlay
            self.group.enter()
            self.functionalityOnHit()
            notifyToGroup(with: .canPlay)
        } else {
            self.providedDataForSelfMapSection[info.hitIndexPath.item] = "mapCellMarked"
            self.playingStatus = .canPlay
            self.group.enter()
            self.functionalityOnHit()
            notifyToGroup(with: .canNotPlay)
        }
    }
    
    private func notifyToGroup(with status: PlayingStatus) {
        group.notify(queue: DispatchQueue.global(qos: .userInteractive)) {
            guard let json = try? JSONEncoder().encode(HitResponse(playingStatus: status)) else {return}
            try? self.multipeerConectivityHandler.multiplayerSession.send(json, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
        }
    }
    
    private func makeDestroyedShipIfItPossible(with segment: MapCellContainedSegment, on indexPath: IndexPath) {
        switch segment {
        case .waterMark:
            break
        case .oneCellShipSegment:
            self.providedDataForOpponentMapSection[indexPath.item] = "OneCellShipBrokenSegment"
            self.hittedShipsCount += 1
        case .oneCellShipRotatedSegment:
            self.providedDataForOpponentMapSection[indexPath.item] = "OneCellShipBrokenSegmentRotated"
            self.hittedShipsCount += 1
        case .twoCellShipFirstSegment:
            if self.providedDataForOpponentMapSection[indexPath.item + 1] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "TwoCellShipBrokenSegmentOne"
                self.providedDataForOpponentMapSection[indexPath.item + 1] = "TwoCellShipBrokenSegmentTwo"
                self.hittedShipsCount += 1
            }
        case .twoCellShipSecondSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 1] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "TwoCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item - 1] = "TwoCellShipBrokenSegmentOne"
                self.hittedShipsCount += 1
            }
        case .twoCellShipRotatedFirstSegment:
            if self.providedDataForOpponentMapSection[indexPath.item + 11] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "TwoCellShipBrokenSegmentOneRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 11] = "TwoCellShipBrokenSegmentTwoRotated"
                self.hittedShipsCount += 1
            }
        case .twoCellShipRotatedSecondSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 11] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "TwoCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 11] = "TwoCellShipBrokenSegmentOneRotated"
                self.hittedShipsCount += 1
            }
        case .threeCellShipFirstSegment:
            if self.providedDataForOpponentMapSection[indexPath.item + 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 2] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "ThreeCellShipBrokenSegmentOne"
                self.providedDataForOpponentMapSection[indexPath.item + 1] = "ThreeCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item + 2] = "ThreeCellShipBrokenSegmentThree"
                self.hittedShipsCount += 1
            }
        case .threeCellShipSecondSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 1] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "ThreeCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item - 1] = "ThreeCellShipBrokenSegmentOne"
                self.providedDataForOpponentMapSection[indexPath.item + 1] = "ThreeCellShipBrokenSegmentThree"
                self.hittedShipsCount += 1
            }
        case .threeCellShipThirdSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 2] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "ThreeCellShipBrokenSegmentThree"
                self.providedDataForOpponentMapSection[indexPath.item - 1] = "ThreeCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item - 2] =  "ThreeCellShipBrokenSegmentOne"
                self.hittedShipsCount += 1
            }
        case .threeCellShipRotatedFirstSegment:
            if self.providedDataForOpponentMapSection[indexPath.item + 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 22] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "ThreeCellShipBrokenSegmentOneRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 11] = "ThreeCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 22] =  "ThreeCellShipBrokenSegmentThreeRotated"
                self.hittedShipsCount += 1
            }
        case .threeCellShipRotatedSecondSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 11] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "ThreeCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 11] = "ThreeCellShipBrokenSegmentOneRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 11] =  "ThreeCellShipBrokenSegmentThreeRotated"
                self.hittedShipsCount += 1
            }
        case .threeCellShipRotatedThirdSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 22] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "ThreeCellShipBrokenSegmentThreeRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 11] = "ThreeCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 22] =  "ThreeCellShipBrokenSegmentOneRotated"
                self.hittedShipsCount += 1
            }
        case .fourCellShipFirstSegment:
            if self.providedDataForOpponentMapSection[indexPath.item + 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 2] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 3] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentOne"
                self.providedDataForOpponentMapSection[indexPath.item + 1] = "FourCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item + 2] =  "FourCellShipBrokenSegmentThree"
                self.providedDataForOpponentMapSection[indexPath.item + 3] =  "FourCellShipBrokenSegmentFour"
                self.hittedShipsCount += 1
            }
        case .fourCellShipSecondSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 2] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item - 1] = "FourCellShipBrokenSegmentOne"
                self.providedDataForOpponentMapSection[indexPath.item + 1] =  "FourCellShipBrokenSegmentThree"
                self.providedDataForOpponentMapSection[indexPath.item + 2] =  "FourCellShipBrokenSegmentFour"
                self.hittedShipsCount += 1
            }
        case .fourCellShipThirdSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 2] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 1] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentThree"
                self.providedDataForOpponentMapSection[indexPath.item - 1] = "FourCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item - 2] =  "FourCellShipBrokenSegmentOne"
                self.providedDataForOpponentMapSection[indexPath.item + 1] =  "FourCellShipBrokenSegmentFour"
                self.hittedShipsCount += 1
            }
        case .fourCellShipFourthSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 1] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 2] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 3] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentFour"
                self.providedDataForOpponentMapSection[indexPath.item - 1] = "FourCellShipBrokenSegmentThree"
                self.providedDataForOpponentMapSection[indexPath.item - 2] =  "FourCellShipBrokenSegmentTwo"
                self.providedDataForOpponentMapSection[indexPath.item - 3] =  "FourCellShipBrokenSegmentOne"
                self.hittedShipsCount += 1
            }
        case .fourCellShipRotatedFirstSegment:
            if self.providedDataForOpponentMapSection[indexPath.item + 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 22] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 33] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentOneRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 11] = "FourCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 22] =  "FourCellShipBrokenSegmentThreeRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 33] =  "FourCellShipBrokenSegmentFourRotated"
                self.hittedShipsCount += 1
            }
        case .fourCellShipRotatedSecondSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 22] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 11] = "FourCellShipBrokenSegmentOneRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 11] =  "FourCellShipBrokenSegmentThreeRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 22] =  "FourCellShipBrokenSegmentFour"
                self.hittedShipsCount += 1
            }
        case .fourCellShipRotatedThirdSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 22] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item + 11] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentThreeRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 11] = "FourCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 22] =  "FourCellShipBrokenSegmentOneRotated"
                self.providedDataForOpponentMapSection[indexPath.item + 11] =  "FourCellShipBrokenSegmentFourRotated"
                self.hittedShipsCount += 1
            }
        case .fourCellShipRotatedFourthSegment:
            if self.providedDataForOpponentMapSection[indexPath.item - 11] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 22] == "mappCelllRedHitted" && self.providedDataForOpponentMapSection[indexPath.item - 33] == "mappCelllRedHitted" {
                self.providedDataForOpponentMapSection[indexPath.item] = "FourCellShipBrokenSegmentFourRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 11] = "FourCellShipBrokenSegmentThree"
                self.providedDataForOpponentMapSection[indexPath.item - 22] =  "FourCellShipBrokenSegmentTwoRotated"
                self.providedDataForOpponentMapSection[indexPath.item - 33] =  "FourCellShipBrokenSegmentOneRotated"
                self.hittedShipsCount += 1
            }
        }
    }
    
    @objc private func timerUpdateSelector() {
        guard self.timerForPlayerAction != nil else {return}
        if self.secondsRemained != 0 {
            self.secondsRemained -= 1
            self.timerForPlayerAction = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdateSelector), userInfo: nil, repeats: false)
        } else {
            self.playingStatus = .canNotPlay
        }
    }
}

struct HitInfo: Codable {
    private(set) var hitIndexPath: IndexPath
    init(hitIndexPath: IndexPath) {
        self.hitIndexPath = hitIndexPath
    }
}

struct HitResponse: Codable {
    private(set) var playingStatus: PlayingStatus
    init( playingStatus: PlayingStatus) {
        self.playingStatus = playingStatus
    }
}
