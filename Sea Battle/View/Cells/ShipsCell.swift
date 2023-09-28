//
//  ShipsCell.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 19.09.23.
//

import UIKit

final class ShipsCell: UICollectionViewCell {
    
    private var shipIndentificator: ShipsIdentifier! = nil
    
    private let shipImage:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configuire(with image: String) {
        self.backgroundColor = .white
        self.backgroundView = UIImageView(image: UIImage(named: "mappCelll"))
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.addSubview(shipImage)
        NSLayoutConstraint.activate([
            shipImage.topAnchor.constraint(equalTo: self.topAnchor),
            shipImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            shipImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shipImage.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
        if !image.isEmpty {
            self.shipImage.image = UIImage(named: image)
            self.shipIndentificator = ShipsIdentifier(rawValue: image)
            self.shipImage.alpha = 1
        } else {
            self.shipImage.alpha = 0
            self.shipIndentificator = nil
        }
    }
    
    func provideSelfShipIndentificator() -> ShipsIdentifier{
        return self.shipIndentificator
    }
    
    func isContainsShip() -> Bool {
        return (self.shipIndentificator != nil)
    }
}
