//
//  ViewModelForPlayersTableView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import Foundation
import MultipeerConnectivity

extension ViewModelForPlayersTableView: PeerIDReciever {
    func getPeerId(peerId: MCPeerID, with type: DataType) {
        self.dataModel.handleIncomingData(data: peerId, with: type)
        self.getDataFromDataModel()
    }
}

final class ViewModelForPlayersTableView {
    
    var functionalityWhenDataRecieved: () -> Void = {}
    
    private var dataModel: DataSourceForPlayersTableView = DataSourceForPlayersTableView()
    private(set) var multipeerConnectivityForPlayers: MultiplayerConectionAsMPCHandler! = nil
    private(set) var givenDataForPlayerNames: [String] = [String]() {
        didSet {
            functionalityWhenDataRecieved()
        }
    }
    private(set) var givenDataForPlayerIcons: [String] = [String]() {
        didSet {
            functionalityWhenDataRecieved()
        }
    }
    
    func setDelegateForConnectivity() {
        multipeerConnectivityForPlayers.delegate = self
    }
    
    func getDataFromDataModel() {
        self.givenDataForPlayerIcons = self.dataModel.provideDataForIcons()
        self.givenDataForPlayerNames = self.dataModel.provideDataForNames()
    }
    
//    func configuireDataModel() {
//        self.dataModel.functionalityWhenDataRecieved = {
//            self.givenDataForPlayerIcons = self.dataModel.provideDataForIcons()
//            self.givenDataForPlayerNames = self.dataModel.provideDataForNames()
//        }
//    }
    
    func providePeerId(at index: IndexPath) -> MCPeerID {
        return self.dataModel.providePeerId(at: index)
    }
    
    func setConnectivityHandler(with handler: MultiplayerConectionAsMPCHandler) {
        self.multipeerConnectivityForPlayers = handler
    }
}
