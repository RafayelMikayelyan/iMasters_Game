//
//  ViewModelForBattleViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//

import Foundation

enum PlayingStatus {
    case canPlay
    case canNotPlay
}

final class ViewModelForBattleViewController {
    
    private var multipeerConectivityHandler: MultiplayerConectionAsMPCHandler! = nil
    private var playingStatus: PlayingStatus! = nil {
        didSet {
            if self.playingStatus == .canPlay {
                self.setTimer()
                self.secondsRemained = 30
            }
            functionalityWhenPlayingStatusChanged()
        }
    }
    private(set) var providedDataForSelfMapSection: [String] = [String]() {
        didSet{
            functionalityWhenDataForSelfMapProvided()
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
    
    init(dataModel: DataSourceForBattleViewController) {
        self.dataModel = dataModel
    }
    
    var functionalityWhenPlayingStatusChanged: () -> Void = {}
    var functionalityWhenTimerUpdates: () -> Void = {}
    var functionalityWhenDataForSelfMapProvided : () -> Void = {}
    var functionalityWhenDataForOpponentMapProvided : () -> Void = {}
    
    func getDataForSelfMap() {
        self.providedDataForSelfMapSection = self.dataModel.provideDataForSelfMapSection()
    }

    func getDataForOpponentMap() {
        self.providedDataForOpponentMapSection = self.dataModel.provideDataForOpponentMapSection()
    }
    
    func setMultipeerConnectivityHandler(with handler: MultiplayerConectionAsMPCHandler) {
        self.multipeerConectivityHandler = handler
        self.multipeerConectivityHandler.addAdvertiserToCloder()
    }
    
    func setPlayingStatus(with status: PlayingStatus) {
        self.playingStatus = status
    }
    
    func providePlayingStatus() -> PlayingStatus {
        return self.playingStatus
    }
    
    func sendData(data: Data?) {
        guard let data else {return}
        try? self.multipeerConectivityHandler.multiplayerSession.send(data, toPeers: self.multipeerConectivityHandler.multiplayerSession.connectedPeers, with: .reliable)
    }
    
    func setTimer() {
        self.timerForPlayerAction = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdateSelector), userInfo: nil, repeats: false)
    }
    
    @objc private func timerUpdateSelector() {
        if self.secondsRemained != 0 {
            self.secondsRemained -= 1
            self.timerForPlayerAction = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdateSelector), userInfo: nil, repeats: false)
        } else {
            self.playingStatus = .canNotPlay
        }
    }
}
