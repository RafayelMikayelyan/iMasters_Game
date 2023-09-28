//
//  CellForMapAndShips.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 19.09.23.
//

import UIKit

final class CellForMapAndShips: UICollectionViewCell {
    
    private var cellContainedItem: MapCellContainedSegment? = nil
        
    private let imageForMapCellOrShip: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageForMapCellHighlight: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
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
        self.addSubview(imageForMapCellOrShip)
        self.addSubview(imageForMapCellHighlight)
        self.imageForMapCellOrShip.image = UIImage(named:image)
        self.imageForMapCellHighlight.image = nil
        self.cellContainedItem = MapCellContainedSegment(rawValue: image)
        NSLayoutConstraint.activate([
            imageForMapCellOrShip.topAnchor.constraint(equalTo: self.topAnchor),
            imageForMapCellOrShip.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageForMapCellOrShip.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageForMapCellOrShip.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageForMapCellHighlight.topAnchor.constraint(equalTo: self.topAnchor),
            imageForMapCellHighlight.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageForMapCellHighlight.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageForMapCellHighlight.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    func configuireByContained(with image: String) {
        self.addSubview(imageForMapCellOrShip)
        self.addSubview(imageForMapCellHighlight)
        imageForMapCellOrShip.image = UIImage(named:"mappCelll")
        imageForMapCellHighlight.image = UIImage(named: image)
        self.cellContainedItem = MapCellContainedSegment(rawValue: image)
        NSLayoutConstraint.activate([
            imageForMapCellOrShip.topAnchor.constraint(equalTo: self.topAnchor),
            imageForMapCellOrShip.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageForMapCellOrShip.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageForMapCellOrShip.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageForMapCellHighlight.topAnchor.constraint(equalTo: self.topAnchor),
            imageForMapCellHighlight.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageForMapCellHighlight.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageForMapCellHighlight.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    func highlightCellWithGreenBackground() {
        if !self.isCellContainedItem() {
            self.imageForMapCellHighlight.image = UIImage(named: "mapCellGreenMark")
        }
    }
    
    func highlightCellWithRedBackground() {
        if !self.isCellContainedItem() {
            self.imageForMapCellHighlight.image = UIImage(named: "mapCellRedMark")
        }
    }
    
    func fixCellBackground() {
        if !self.isCellContainedItem() {
            self.imageForMapCellHighlight.image = nil
        }
    }
    
    func isCellContainedItem() -> Bool {
        return (self.cellContainedItem != nil)
    }
    
    func provideSelfShipIndentificator() -> ShipsIdentifier?{
        switch self.cellContainedItem {
        case .fourCellShipFirstSegment,.fourCellShipSecondSegment,.fourCellShipThirdSegment,.fourCellShipFourthSegment:
            return .fourCellShip
        case .fourCellShipRotatedFirstSegment,.fourCellShipRotatedSecondSegment,.fourCellShipRotatedThirdSegment,.fourCellShipRotatedFourthSegment:
            return .fourCellShipRotated
        case .threeCellShipFirstSegment,.threeCellShipSecondSegment,.threeCellShipThirdSegment:
            return .threeCellShip
        case .threeCellShipRotatedFirstSegment,.threeCellShipRotatedSecondSegment,.threeCellShipRotatedThirdSegment:
            return .threeCellShipRotated
        case .twoCellShipFirstSegment, .twoCellShipSecondSegment:
            return .twoCellShip
        case .twoCellShipRotatedFirstSegment, .twoCellShipRotatedSecondSegment:
            return .twoCellShipRotated
        case .oneCellShipSegment:
            return .oneCellShip
        case .oneCellShipRotatedSegment:
            return .oneCellShipRotated
        default:
            return nil
        }
    }
}

