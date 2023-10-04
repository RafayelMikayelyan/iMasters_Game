//
//  CellForPlayersTableView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import UIKit

final class CellForPlayersTableView: UITableViewCell {
    
    private let playerIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let connectionStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configuration(name:String,icon:Data?) {
        
        self.backgroundColor = .cyan.withAlphaComponent(0.1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        
        if let icon {
            self.playerIcon.image = UIImage(data: icon)
        }
        self.playerNameLabel.text = name
        
        self.contentView.addSubview(playerIcon)
        self.contentView.addSubview(playerNameLabel)
        self.contentView.addSubview(connectionStateLabel)
        
        NSLayoutConstraint.activate([
            playerIcon.topAnchor.constraint(equalTo: self.topAnchor,constant: 7),
            playerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -7),
            playerIcon.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 15),
            playerIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            connectionStateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            connectionStateLabel.leftAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: 20)
        ])
    }
    
    func setStateLabelText(with text: String) {
        self.connectionStateLabel.text = text
    }
    
}
