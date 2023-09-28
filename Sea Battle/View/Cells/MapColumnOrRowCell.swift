//
//  MapColumnOrRowCell.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 22.09.23.
//

import UIKit

final class MapColumnOrRowCell: UICollectionViewCell {
    
    private var cellIndentifier: RowColIdentifier! = nil
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mappCelll")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let colRowIdentificatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configuire(with indentificator: String) {
        self.colRowIdentificatorLabel.text = indentificator
        self.cellIndentifier = RowColIdentifier(rawValue: indentificator)
        self.addSubview(backgroundImage)
        self.addSubview(colRowIdentificatorLabel)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            colRowIdentificatorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            colRowIdentificatorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        self.colRowIdentificatorLabel.font = .boldSystemFont(ofSize: self.bounds.height-2)
    }
}
