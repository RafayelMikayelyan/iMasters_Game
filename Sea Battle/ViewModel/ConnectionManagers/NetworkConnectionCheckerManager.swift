//
//  NetworkConnectionCheckerManager.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 29.09.23.
//

import Network

enum ConnectionStatus {
    case connected
    case notConnected
}

protocol NetworkConnectionCheckerManagerDelegate: AnyObject {
    func provideStatus(_sender: NetworkConnectionCheckerManager,status: ConnectionStatus)
}

final class NetworkConnectionCheckerManager {
    
    private let networkMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let nwInterface = NWInterface.InterfaceType
    private let queueForHandlingMonitoringEvents = DispatchQueue.global(qos: .userInteractive)
    weak var delegate: NetworkConnectionCheckerManagerDelegate?
    
    func provideConnectionStatus() {
        let group = DispatchGroup()
        var connectionStatus: ConnectionStatus = .notConnected
        self.networkMonitor.start(queue: queueForHandlingMonitoringEvents)
        group.enter()
        networkMonitor.pathUpdateHandler = { path in
            group.enter()
            if path.status == .satisfied {
                connectionStatus = .connected
            } else {
                connectionStatus = .notConnected
            }
            group.leave()// there are something confusional, if I bring seconf group.leave() to 36 line , our DispatchQueue.global() is concurrent queue so firs group.enter and group.leave executes imideatly and i don't see changes
            group.leave()
        }
        group.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            self.delegate?.provideStatus(_sender: self, status: connectionStatus)
            self.networkMonitor.cancel()// canceling to stop recieving connection status events geting because we get in dispatch group negative count of enters and leaves due to line 29 and 38
        }
    }
}
