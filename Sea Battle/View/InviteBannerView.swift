//
//  InviteBannerView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 27.09.23.
//

import UIKit

@objc protocol InviteBannerViewTarget {
    @objc func inviteBannerTarhetForGet(_ sender: UIButton)
    @objc func inviteBannerTarhetForCancel(_ sender: UIButton)
}

final class InviteBannerView: UIView {
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "BannerBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerIcon:UIImageView = {
        let imageView = UIImageView()
        imageView.image = DataAboutPlayerSingleton.shared.providePlayerIcon()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerNameLabel: UILabel = {
        let label = UILabel()
        label.text = DataAboutPlayerSingleton.shared.providePlayerName()
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.minimumScaleFactor = 0.2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inviteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let getInviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get", for: .normal)
        NSLayoutConstraint.activate([
            button.titleLabel!.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            button.titleLabel!.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.7)
        ])
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue.withAlphaComponent(0.1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addAction(UIAction(handler: { _ in
            UIView.animate(withDuration: 0.2) {
                button.backgroundColor = .white.withAlphaComponent(0.1)
                button.backgroundColor = .blue.withAlphaComponent(0.1)
            }
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelInviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        NSLayoutConstraint.activate([
            button.titleLabel!.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            button.titleLabel!.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.7)
        ])
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue.withAlphaComponent(0.1)
        button.titleLabel?.font = .boldSystemFont(ofSize: 23)
        button.addAction(UIAction(handler: { _ in
            UIView.animate(withDuration: 0.2) {
                button.backgroundColor = .white.withAlphaComponent(0.1)
                button.backgroundColor = .blue.withAlphaComponent(0.1)
            }
        }), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .black
        self.layer.cornerRadius = 20
        self.clipsToBounds = true

        self.inviteLabel.text = "\(self.playerNameLabel.text ?? "") ivite you to battle."
        
        self.addSubview(backgroundImage)
        self.addSubview(playerIcon)
        self.addSubview(playerNameLabel)
        self.addSubview(inviteLabel)
        self.addSubview(getInviteButton)
        self.addSubview(cancelInviteButton)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            inviteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            inviteLabel.topAnchor.constraint(equalTo: self.topAnchor),
            playerIcon.topAnchor.constraint(equalTo: inviteLabel.bottomAnchor,constant: 7),
            playerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -7),
            playerIcon.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 15),
            playerIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            getInviteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 100),
            getInviteButton.topAnchor.constraint(equalTo: playerIcon.topAnchor,constant: 10),
            cancelInviteButton.centerXAnchor.constraint(equalTo: getInviteButton.centerXAnchor),
            cancelInviteButton.topAnchor.constraint(equalTo: getInviteButton.bottomAnchor,constant: 7),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .black
        self.layer.cornerRadius = 20
        self.clipsToBounds = true

        self.inviteLabel.text = "\(self.playerNameLabel.text ?? "") ivite you to battle."
        
        self.addSubview(backgroundImage)
        self.addSubview(playerIcon)
        self.addSubview(playerNameLabel)
        self.addSubview(inviteLabel)
        self.addSubview(getInviteButton)
        self.addSubview(cancelInviteButton)
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            inviteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            inviteLabel.topAnchor.constraint(equalTo: self.topAnchor),
            playerIcon.topAnchor.constraint(equalTo: inviteLabel.bottomAnchor,constant: 7),
            playerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            playerIcon.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 15),
            playerIcon.widthAnchor.constraint(equalToConstant: 150),
            playerNameLabel.leftAnchor.constraint(equalTo: self.playerIcon.leftAnchor,constant: 7),
            playerNameLabel.rightAnchor.constraint(equalTo: self.playerIcon.rightAnchor,constant: -4),
            playerNameLabel.bottomAnchor.constraint(equalTo: playerIcon.bottomAnchor,constant: -3),
            getInviteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 100),
            getInviteButton.topAnchor.constraint(equalTo: playerIcon.topAnchor,constant: 10),
            cancelInviteButton.centerXAnchor.constraint(equalTo: getInviteButton.centerXAnchor),
            cancelInviteButton.topAnchor.constraint(equalTo: getInviteButton.bottomAnchor,constant: 7),
        ])
    }
    
    func setBannerPlayerIconName(with data: PlayerContextualData) {
        self.playerIcon.image = UIImage(data: data.playerIconDescription)
        self.playerNameLabel.text = data.playerName
    }
    
    func setTargetToGetButton(_ target: InviteBannerViewTarget) {
        self.getInviteButton.addTarget(target, action: #selector(target.inviteBannerTarhetForGet), for: .touchUpInside)
    }
    
    func setTargetToCancelButton(_ target: InviteBannerViewTarget) {
        self.cancelInviteButton.addTarget(target, action: #selector(target.inviteBannerTarhetForCancel), for: .touchUpInside)
    }
}
