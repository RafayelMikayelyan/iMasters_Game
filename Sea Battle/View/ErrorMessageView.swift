//
//  ErrorMessageView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//

import UIKit

final class ErrorMessageView: UIView {
    
    private let errorLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red.withAlphaComponent(0.8)
        label.text = "Please set all ships"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 15
        self.backgroundColor = .white.withAlphaComponent(0.5)
        
        self.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.errorLabel.widthAnchor, multiplier: 1.2),
            self.heightAnchor.constraint(equalTo: self.errorLabel.heightAnchor, multiplier: 1.2),
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 15
        self.backgroundColor = .white.withAlphaComponent(0.4)
        
        self.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            
        ])
    }
    
    func setLabelText(with text: String) {
        self.errorLabel.text = text
    }
}
