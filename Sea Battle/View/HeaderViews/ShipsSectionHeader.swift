//
//  ShipsSectionHeader.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 21.09.23.
//

import UIKit

final class ShipsSectionHeader: UICollectionReusableView {
    
    var rotateRightButtonHandler: UIAction!
    var rotateLeftButtonHandler: UIAction!
    
    private let rotateRightButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rotate.right.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rotateLeftButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rotate.left.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        self.rotateLeftButton.addAction(self.rotateLeftButtonHandler, for: .touchUpInside)
        self.rotateRightButton.addAction(self.rotateRightButtonHandler, for: .touchUpInside)
        
        self.addSubview(titleLabel)
        self.addSubview(rotateRightButton)
        self.addSubview(rotateLeftButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rotateRightButton.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -20),
            rotateRightButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rotateRightButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            rotateLeftButton.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            rotateLeftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rotateLeftButton.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
}


