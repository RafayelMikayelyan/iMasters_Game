//
//  DataSourceForBattleViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//

import Foundation

struct DataSourceForBattleViewController {
    
    private var dataForSelfMapSection: [String]
    
    private var dataForOpponentMapSection: [String] = {
        let dict:[Int:String] = [
            11:"A",
            22:"B",
            33:"C",
            44:"D",
            55:"E",
            66:"F",
            77:"G",
            88:"H",
            99:"I",
            110:"J"
        ]
        var data:[String] = [""]
        for i in 1...10 {
            data.append("\(i)")
        }
        for i in 11...120 {
            if dict[i] != nil {
                data.append(dict[i]!)
            } else {
                data.append("mappCelll")
            }
        }
        return data
    }()
    
    init(dataForSelfMapSection: [String]) {
        self.dataForSelfMapSection = dataForSelfMapSection
    }
    
    func provideDataForSelfMapSection() -> [String] {
        return self.dataForSelfMapSection
    }
    
    func provideDataForOpponentMapSection() -> [String] {
        return self.dataForOpponentMapSection
    }
    
}
