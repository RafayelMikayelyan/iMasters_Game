//
//  PlayerCellForBattleViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//

import UIKit

final class PlayerCellForBattleViewController: UICollectionViewCell {
    
    private let playerIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ShipsMapsBackground")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let opponentIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ShipsMapsBackground")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ashot"
        label.font = .boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let opponentNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ashot"
        label.font = .boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(playerIcon)
        self.addSubview(playerNameLabel)
        self.addSubview(opponentIcon)
        self.addSubview(opponentNameLabel)
        
        NSLayoutConstraint.activate([
            playerIcon.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            playerIcon.topAnchor.constraint(equalTo: self.topAnchor),
            playerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            playerIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            opponentIcon.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10),
            opponentIcon.topAnchor.constraint(equalTo: self.topAnchor),
            opponentIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            opponentIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            opponentNameLabel.leftAnchor.constraint(equalTo: self.opponentIcon.leftAnchor,constant: 7),
            opponentNameLabel.rightAnchor.constraint(equalTo: self.opponentIcon.rightAnchor,constant: -4),
            opponentNameLabel.bottomAnchor.constraint(equalTo: opponentIcon.bottomAnchor,constant: -3),
        ])
    }
    
    required init?(coder:NSCoder) {
        super.init(coder: coder)
       
        self.addSubview(playerIcon)
        self.addSubview(playerNameLabel)
        self.addSubview(opponentIcon)
        self.addSubview(opponentNameLabel)
        
        NSLayoutConstraint.activate([
            playerIcon.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            playerIcon.topAnchor.constraint(equalTo: self.topAnchor),
            playerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            playerIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            opponentIcon.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10),
            opponentIcon.topAnchor.constraint(equalTo: self.topAnchor),
            opponentIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            opponentIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            opponentNameLabel.leftAnchor.constraint(equalTo: self.opponentIcon.leftAnchor,constant: 7),
            opponentNameLabel.rightAnchor.constraint(equalTo: self.opponentIcon.rightAnchor,constant: -4),
            opponentNameLabel.bottomAnchor.constraint(equalTo: opponentIcon.bottomAnchor,constant: -3),
        ])
    }
    
}
