//
//  AdvertiserSessionsCloser.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 01.10.23.
//

import MultipeerConnectivity

final class AdvertiserSessionsCloser {
    
    static var shared: AdvertiserSessionsCloser {
        return AdvertiserSessionsCloser()
    }
    
    private var advertisersSet: Set<MCNearbyServiceAdvertiser> = Set<MCNearbyServiceAdvertiser>()
    
    private init(){}
    
    func addAdvertiserAssintent(with advertiser: MCNearbyServiceAdvertiser) {
        self.advertisersSet.insert(advertiser)
    }
    
    func closeAdvertisersSessions() {
        for i in self.advertisersSet {
            i.stopAdvertisingPeer()
        }
    }
}
