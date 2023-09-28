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

struct DataSourceForPlayersTableView {
    
    private var dataSource: [MCPeerID] = [MCPeerID]() {
        didSet {
            functionalityWhenDataRecieved()
        }
    }
    
    var functionalityWhenDataRecieved: () -> Void = {}
    
    func provideDataForNames() -> [String] {
        return self.dataSource.map({String(($0.displayName.split(separator: ","))[0])})
    }
    
    func provideDataForIcons() -> [String] {
        return self.dataSource.map({String(($0.displayName.split(separator: ","))[1])})
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
    
    func providePeerId(at index: IndexPath) -> MCPeerID {
        return self.dataSource[index.row]
    }
}
