//
//  PlayersTableViewHeaderView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import UIKit

final class PlayersTableViewHeaderView: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 27)
        label.textColor = .white
        label.text = "Players waiting to join"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.backgroundView = UIImageView(image: UIImage(named: "BannerBackground"))
        self.backgroundView?.alpha = 0.3// changing background color table view's header footer view is not supported
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
