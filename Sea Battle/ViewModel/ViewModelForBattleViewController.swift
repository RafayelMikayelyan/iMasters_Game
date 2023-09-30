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
    private var playingStatus: PlayingStatus! = nil
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
    
    private var dataModel: DataSourceForBattleViewController
    
    init(dataModel: DataSourceForBattleViewController) {
        self.dataModel = dataModel
    }
    
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
}
