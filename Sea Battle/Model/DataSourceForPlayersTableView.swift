//
//  DataSourceForPlayersTableView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import Foundation
import MultipeerConnectivity

enum DataType {
    case lost
    case get
}

enum ConnectingState {
    case notNonnected
    case connecting
    case connected
    case networkMissing
    case canceled
}

struct DataSourceForPlayersTableView {
    
    private var dataSource: [MCPeerID] = [MCPeerID]() {
        didSet {
            functionalityWhenDataRecieved()
        }
    }
    
    private var connectingState: [ConnectingState] = [ConnectingState]()
    
    var functionalityWhenDataRecieved: () -> Void = {}
    
    func provideDataForNames() -> [String] {
        return self.dataSource.map({$0.displayName})
    }
    
    mutating func setUpWithConnectionStates() -> [ConnectingState] {
        self.connectingState = [ConnectingState].init(repeating: .notNonnected, count: self.dataSource.count)
        return self.connectingState
    }
    
    func provideDataForIcons() -> [Data] {
        return self.dataSource.map({$0.discoveryData!})
    }
    
    mutating func handleIncomingData(data: MCPeerID, with type: DataType) {
        switch type {
        case .lost:
            self.dataSource.removeAll(where: {$0 === data})
        case .get:
            self.dataSource.append(data)
            print(self.dataSource)
        }
    }
    
    mutating func setConnectionState(for index: IndexPath, with state: ConnectingState) {
        self.connectingState[index.row] = state
    }
    
    func providePeerId(at index: IndexPath) -> MCPeerID {
        return self.dataSource[index.row]
    }
}
