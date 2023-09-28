//
//  DecorationViewForMapAndShips.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 19.09.23.
//

import UIKit

final class DecorationViewForMapAndShips: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.backgroundColor = .cyan.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 15
        self.backgroundColor = .cyan.withAlphaComponent(0.2)
    }
}

