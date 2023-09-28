//
//  MainPageViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 28.09.23.
//

import UIKit

final class MainPageViewController: UIViewController {
    
    private let seaBattleButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sea Battle", for: .normal)
        button.titleLabel?.textColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let chessButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sea Battle", for: .normal)
        button.titleLabel?.textColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(seaBattleButton)
        self.view.addSubview(chessButton)
        
        NSLayoutConstraint.activate([
            self.seaBattleButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.seaBattleButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.chessButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.chessButton.topAnchor.constraint(equalTo: self.seaBattleButton.bottomAnchor,constant: 10)
        ])
        
        self.seaBattleButton.addTarget(self, action: #selector(selectorSea), for: .touchUpInside)
    }
    
    @objc func selectorSea() {
        self.show(ShipMapConfigurationViewController(), sender: nil)
    }
}
