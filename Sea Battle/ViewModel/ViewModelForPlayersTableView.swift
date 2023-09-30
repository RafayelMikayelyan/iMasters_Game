//
//  ViewModelForPlayersTableView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import Foundation
import MultipeerConnectivity

extension ViewModelForPlayersTableView: PeerIDRecieverDelegate {
   
    
    func getPeerId(_ sender: MultiplayerConectionAsMPCHandler,peerId: MCPeerID, with type: DataType) {
        self.dataModel.handleIncomingData(data: peerId, with: type)
        self.getDataFromDataModel()
    }
    
    func setConnectionState(_ sender: MultiplayerConectionAsMPCHandler,for index: IndexPath, with state: ConnectingState) {
        self.dataModel.setConnectionState(for: index, with: state)
        self.givenDataForConnectionStates[index.row] = state
        switch state {
        case .networkMissing:
            self.functionalityWhenConnectionFailed()
        case .canceled:
            self.functionalityWhenConnectionFailed()
        default:
            break
        }
    }
}

final class ViewModelForPlayersTableView {
    
    var functionalityWhenDataRecieved: () -> Void = {}
    var functionalityWhenConnectionFailed: () -> Void = {}
    
    private var dataModel: DataSourceForPlayersTableView = DataSourceForPlayersTableView()
    private(set) var multipeerConnectivityForPlayers: MultiplayerConectionAsMPCHandler! = nil
    private(set) var givenDataForPlayerNames: [String] = [String]() {
        didSet {
            functionalityWhenDataRecieved()
        }
    }
    private(set) var givenDataForConnectionStates: [ConnectingState] = [ConnectingState]() {
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
        self.givenDataForConnectionStates = self.dataModel.setUpWithConnectionStates()
    }
    
    func providePeerId(at index: IndexPath) -> MCPeerID {
        return self.dataModel.providePeerId(at: index)
    }
    
    func setConnectivityHandler(with handler: MultiplayerConectionAsMPCHandler) {
        self.multipeerConnectivityForPlayers = handler
    }

}
