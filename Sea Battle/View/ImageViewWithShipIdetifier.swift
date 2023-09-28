//
//  ImageViewWithShipIdetifier.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 22.09.23.
//

import UIKit

final class ImageViewWithShipIdetifier: UIImageView {
    
    private var imageIdentifierAsShip:ShipsIdentifier! = nil
    
    func setImageIdentifier(with idetifier: ShipsIdentifier) {
        self.imageIdentifierAsShip = idetifier
    }
    
    func getImageIdentifier() -> ShipsIdentifier? {
        return self.imageIdentifierAsShip
    }
}
