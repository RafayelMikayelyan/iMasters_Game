//
//  DataAboutPlayerSingleton.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 01.10.23.
//

import UIKit.UIImage

final class DataAboutPlayerSingleton {
    static var shared: DataAboutPlayerSingleton {
        return DataAboutPlayerSingleton()
    }
    
    private var playerName: String = "Player"
    private var playerIcon: UIImage? = UIImage(named: "defaultPlayerIcon")
    
    private init() {}
    
    func setPlayerName(with name: String) {
        self.playerName = name
    }
    
    func setPlayerIcon(with image: UIImage) {
        self.playerIcon = image
    }
    
    func providePlayerName() -> String {
        return self.playerName
    }
    
    func providePlayerIcon() -> UIImage? {
        return self.playerIcon
    }
}
