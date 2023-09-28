//
//  PlayersTableViewFooterView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import UIKit

final class PlayersTableViewFooterView: UITableViewHeaderFooterView {
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    func configuire(with message:String) {
        
        self.backgroundView = UIImageView(image: UIImage(named: "BannerBackground"))
        self.backgroundView?.alpha = 0.3// changing background color table view's header footer view is not supported
        
        self.addSubview(activityIndicator)
        self.addSubview(searchLabel)
        
        searchLabel.text = message
        self.activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            self.searchLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10),
            self.searchLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.activityIndicator.leftAnchor.constraint(equalTo: self.searchLabel.rightAnchor,constant: 5),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
