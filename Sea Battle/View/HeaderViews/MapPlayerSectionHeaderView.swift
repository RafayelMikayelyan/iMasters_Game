//
//  MapPlayerSectionHeaderView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 19.09.23.
//

import UIKit

final class MapPlayerSectionHeaderView: UICollectionReusableView {
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder:NSCoder) {
        super.init(coder: coder)
    }
    
    func configuire(with title: String) {
        self.layer.cornerRadius = 15
        self.backgroundColor = .clear
        
        self.titleLabel.text = title
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

