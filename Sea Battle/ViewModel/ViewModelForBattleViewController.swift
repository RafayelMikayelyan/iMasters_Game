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
            self.timerForConnectionReesteablish.invalidate()
            self.timerForConnectionReesteablish.fire()
            self.functionalityWhenConnectionReesteablished()
            if self.playingStatus == .canPlay {
                self.playingStatus = .canPlay
            }
        }
        
        if state == .notConnected {
            //MARK: - Remamber that its require any tyme to disconnect so the timer to waiting add when you enshure that session pass to disconnected state
            if self.connectorStatus == .starter {
                self.desablingSetterOfCollectionView()
                self.timerForPlayerAction.invalidate()
                self.timerForPlayerAction.fire()
                DispatchQueue.main.async(qos: .userInteractive) {
                    self.timerForConnectionReesteablish = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                        guard let self else {return}
                        if self.secondsRemainedForConnect != 0 {
                            self.secondsRemainedForConnect -= 1
                        } else {
                            self.playingStatus = .canPlay
                        }
                    })
                }
                self.multipeerConectivityHandler.browserForConnect.startBrowsingForPeers()
                self.functionalityWhenOpponentDisconnected()
            }
            if self.connectorStatus == .joiner {
                //MARK: - Its allready is handled by Apple Thank YOU Apple
                //nw_socket_handle_socket_event
                self.desablingSetterOfCollectionView()
                self.timerForPlayerAction.invalidate()
                self.timerForPlayerAction.fire()
                DispatchQueue.main.async(qos: .userInteractive) {
                    self.timerForConnectionReesteablish = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                        guard let self else {return}
                        if self.secondsRemainedForConnect != 0 {
                            self.secondsRemainedForConnect -= 1
                        } else {
                            self.playingStatus = .canPlay
                        }
                    })
                }
                self.functionalityWhenOpponentDisconnected()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let decodedData = try? JSONDecoder().decode(HitInfo.self, from: data) {
            self.handleHitSelfMap(by: decodedData)
        }
        if let decodedData = try? JSONDecoder().decode(HitResponse.self, from: data) {
            self.setPlayingStatus(with: decodedData.playingStatus)  
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
        if self.connecedToPeer.count == 1 {
            if peerID == self.connecedToPeer.first! && !self.multipeerConectivityHandler.multiplayerSession.connectedPeers.isEmpty && self.playingStatus == .canPlay {// if joiner leave the game and connection lost, when he come back starter found his peerID and if he had lost connection he pass into if block on bottom and never pass into this block but when he had not lost the connection he pass into this block first and by return leave this delegate function whole
                self.playingStatus = .canPlay
                return
            }
            if peerID == self.connecedToPeer.first! {
                if self.connectorStatus == .starter {
                    self.multipeerConectivityHandler.browserForConnect.invitePeer(peerID, to: self.multipeerConectivityHandler.multiplayerSession, withContext: nil, timeout: 30)
                    self.multipeerConectivityHandler.browserForConnect.stopBrowsingForPeers()
                }
                return
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if self.connecedToPeer.count == 1 {
            if peerID == self.connecedToPeer.first! {
                self.desablingSetterOfCollectionView()
                self.timerForPlayerAction.invalidate()
                self.timerForPlayerAction.fire()
            }
        }
    }
}

extension ViewModelForBattleViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if self.connecedToPeer.count == 1 {
            if peerID == self.connecedToPeer.first! {// That equality works great!!!!!
                invitationHandler(true,self.multipeerConectivityHandler.multiplayerSession)
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
    private var hittedShipsCount: Int = 0 {
        didSet {
            
        }
    }
    private(set) var group = DispatchGroup()
    private var playingStatus: PlayingStatus! = nil {
        didSet {
            if self.playingStatus == .canPlay {
                self.secondsRemained = 29
                self.setTimer()
            } else {
                self.timerForPlayerAction.invalidate()
                self.timerForPlayerAction.fire()
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
    
    private(set) var playerScores: Int = 0 {
        didSet {
            self.functionalityWhenScoresChanged()
        }
    }
    
    private(set) var opponentScores: Int = 0 {
        didSet {
            self.functionalityWhenScoresChanged()
        }
    }
    
    private(set) var providedDataForOpponentMapSection: [String] = [String]() {
        didSet{
            functionalityWhenDataForOpponentMapProvided()
        }
    }
    
    private(set) var secondsRemained: Int = 30 {
        didSet {
                self.functionalityWhenTimerUpdates()
        }
    }
    
    private(set) var secondsRemainedForConnect: Int = 59 {
        didSet {
            self.functionalityWhenTimerUpdatesWaitingOpponent()
        }
    }
    
    private var dataModel: DataSourceForBattleViewController
    
    private var timerForConnectionReesteablish: Timer = Timer()
    
    private var timerForPlayerAction: Timer = Timer()
    
    init(dataModel: DataSourceForBattleViewController, opponentPlayer: SeaBattlePlayer,connectorStatus: ConnectorStatus) {
        self.dataModel = dataModel
        self.opponentPlayer = opponentPlayer
        self.connectorStatus = connectorStatus
    }
    
    var functionalityWhenPlayingStatusChanged: () -> Void = {}
    var functionalityWhenTimerUpdates: () -> Void = {}
    var functionalityWhenTimerUpdatesWaitingOpponent: () -> Void = {}
    var functionalityWhenDataForSelfMapProvided : () -> Void = {}
    var functionalityWhenDataForOpponentMapProvided : () -> Void = {}
    var functionalityOnHit: () -> Void = {}
    var functionalityWhenOpponentDisconnected: () -> Void = {}
    var functionalityWhenScoresChanged: () -> Void = {}
    var desablingSetterOfCollectionView: () -> Void = {}
    var functionalityWhenConnectionReesteablished: () -> Void = {}
    
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
        self.timerForPlayerAction.invalidate()
        self.timerForPlayerAction.fire()
        DispatchQueue.main.async(qos: .userInteractive) {// FOR WHAT????
            self.timerForPlayerAction = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] timer in
                guard let self else {return}
                if self.secondsRemained != 0 {
                    self.secondsRemained -= 1
                } else {
                    self.playingStatus = .canNotPlay
                    guard let json = try? JSONEncoder().encode(HitResponse(playingStatus: .canPlay)) else {return}
                    try? self.multipeerConectivityHandler.multiplayerSession.send(json, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
                }
            })
        }
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
            switch segment {
            case .waterMark:
                break
            case .oneCellShipSegment,.oneCellShipRotatedSegment:
                self.playerScores += 10
            case .twoCellShipFirstSegment,.twoCellShipSecondSegment,.twoCellShipRotatedFirstSegment,.twoCellShipRotatedSecondSegment:
                self.playerScores += 20
            case .threeCellShipFirstSegment,.threeCellShipSecondSegment,.threeCellShipThirdSegment,.threeCellShipRotatedFirstSegment,.threeCellShipRotatedSecondSegment,.threeCellShipRotatedThirdSegment:
                self.playerScores += 30
            case .fourCellShipFirstSegment,.fourCellShipSecondSegment,.fourCellShipThirdSegment,.fourCellShipFourthSegment,.fourCellShipRotatedFirstSegment,.fourCellShipRotatedSecondSegment,.fourCellShipRotatedThirdSegment,.fourCellShipRotatedFourthSegment:
                self.playerScores += 40
            }
        } else {
            if self.opponentPlayer.mapData[indexPath.item] == "mappCelll" {
                guard let json = try? JSONEncoder().encode(HitInfo(hitIndexPath: indexPath)) else {return}
                self.providedDataForOpponentMapSection[indexPath.item] = "mappCelllMineShadow"
                try? self.multipeerConectivityHandler.multiplayerSession.send(json, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
            }
        }
    }
    
    func handleHitSelfMap(by info: HitInfo) {
        self.playingStatus = .canNotPlay
        self.isStartPoint = false
        if let segment = MapCellContainedSegment(rawValue: self.providedDataForSelfMapSection[info.hitIndexPath.item]) {
            self.providedDataForSelfMapSection[info.hitIndexPath.item] += "Hitted"
            self.playingStatus = .canNotPlay
            switch segment {
            case .waterMark:
                break
            case .oneCellShipSegment,.oneCellShipRotatedSegment:
                self.opponentScores += 10
            case .twoCellShipFirstSegment,.twoCellShipSecondSegment,.twoCellShipRotatedFirstSegment,.twoCellShipRotatedSecondSegment:
                self.opponentScores += 20
            case .threeCellShipFirstSegment,.threeCellShipSecondSegment,.threeCellShipThirdSegment,.threeCellShipRotatedFirstSegment,.threeCellShipRotatedSecondSegment,.threeCellShipRotatedThirdSegment:
                self.opponentScores += 30
            case .fourCellShipFirstSegment,.fourCellShipSecondSegment,.fourCellShipThirdSegment,.fourCellShipFourthSegment,.fourCellShipRotatedFirstSegment,.fourCellShipRotatedSecondSegment,.fourCellShipRotatedThirdSegment,.fourCellShipRotatedFourthSegment:
                self.opponentScores += 40
            }
            self.group.enter()
            self.functionalityOnHit()
            notifyToGroup(with: .canPlay)
        } else {
            self.providedDataForSelfMapSection[info.hitIndexPath.item] = "mapCellMarked"
            self.group.enter()
            self.functionalityOnHit()
            notifyToGroup(with: .canNotPlay)
        }
    }
    
    private func notifyToGroup(with status: PlayingStatus) {
        group.notify(queue: DispatchQueue.global(qos: .userInteractive)) {
            guard let json = try? JSONEncoder().encode(HitResponse(playingStatus: status)) else {return}
            try? self.multipeerConectivityHandler.multiplayerSession.send(json, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
            if status == .canPlay {
                self.playingStatus = .canNotPlay// there are setted from background thread and so this error about timer was accured, but for what i must set it in main thread?
            } else {
                self.playingStatus = .canPlay
            }
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
