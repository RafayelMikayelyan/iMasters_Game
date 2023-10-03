//
//  DataAboutPlayerSingleton.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 01.10.23.
//

import UIKit.UIImage

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}

final class DataAboutPlayerSingleton {
    
    static var shared: DataAboutPlayerSingleton = DataAboutPlayerSingleton()
    
    private var playerName: String = "Player"
    private var playerIcon: UIImage? = UIImage(named: "defaultBoyPlayerIcon")
    private var iconDataDescription: Data? {
        return playerIcon?.jpegData(compressionQuality: 1)
    }
    private var playerGender: String! = "boy"
    private var playerInfo: SeaBattlePlayer! = nil
    
    private init() {}
    
    func setPlayerName(with name: String) {
        Self.shared.playerName = name
    }
    
    func setPlayerIcon(with image: UIImage) {
        Self.shared.playerIcon = image
    }
    
    func setPlayerGender(with gender: String) {
        Self.shared.playerGender = gender
        if Self.shared.playerIcon == nil {
            if gender == "boy" {
                Self.shared.playerIcon = UIImage(named: "defaultBoyPlayerIcon")
            } else {
                Self.shared.playerIcon = UIImage(named: "defaultGirlPlayerIcon")
            }
        }
    }
    
    func setPlayer(with mapInfo: [String]) {
        DataAboutPlayerSingleton.shared.playerInfo = SeaBattlePlayer(playerName: Self.shared.playerName, playerIconDescription: Self.shared.iconDataDescription!, playergender: Self.shared.playerGender, mapData: mapInfo)
    }
    
    func providePlayer() -> SeaBattlePlayer {
        return Self.shared.playerInfo
    }
    
    func providePlayerName() -> String {
        return Self.shared.playerName
    }
    
    func providePlayerIcon() -> UIImage? {
        return Self.shared.playerIcon
    }
    
    func provideIconDescription() -> Data {
        guard let data = Self.shared.iconDataDescription else {return Data.init()}
        return data
    }
    
    func providePlayerGender() -> String {
        return Self.shared.playerGender
    }
}

struct SeaBattlePlayer: Codable {
    private(set) var playerName:String
    private(set) var playerIconDescription: Data
    private(set) var playergender: String
    private(set) var mapData:[String]
    
    init(playerName: String, playerIconDescription: Data, playergender: String, mapData: [String]) {
        self.playerName = playerName
        self.playerIconDescription = playerIconDescription
        self.playergender = playergender
        self.mapData = mapData
    }
}

struct PlayerContextualData: Codable {
    private(set) var playerName:String
    private(set) var playerIconDescription: Data

    init(playerName: String, playerIconDescription: Data) {
        self.playerName = playerName
        self.playerIconDescription = playerIconDescription
    }
}
