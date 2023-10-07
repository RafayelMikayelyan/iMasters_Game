//
//  xaxaqar.swift
//  miViewTexadrelMyusiMej
//
//  Created by Saq on 12/17/20.
//  Copyright © 2020 Saq. All rights reserved.
//

import UIKit

enum PlayerType:String {
    case white = "white"
    case black = "black"
}
enum Rank:String {
    case pown = "Pawn"
    case queen = "Queen"
    case rook = "Rook"
    case bishop = "Bishop"
    case king = "King"
    case knight = "Knight"
}

class Xaxaqar: UIImageView {
    
    
    
    var playerType:PlayerType!
    var row:Int = 0
    var col:Int = 0
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    var rank:Rank!
    
    init(frame: CGRect, type:PlayerType, rankType:Rank) {
        super.init(frame: frame)
        playerType = type
        
        self.backgroundColor = .clear
        rank = rankType
        let imageName:String = "\(rank.rawValue)-\(playerType.rawValue)"
        let image = UIImage(named: imageName)
        self.image = image
        self.isUserInteractionEnabled = true
        
    }
    
    
    func qayl(to:(Int,Int)) -> Bool {
        switch (rank,playerType) {
        case (.knight,_):
            return dziuQayl(to: to)
        case (.pown,let type):
            if type == .black {
                return pawnQaylSev(to: to)
            }
            if type == .white {
                return pawnQaylSpitak(to: to)
            }
        case (.rook,_):
            return  rookQayl(to: to)
            
        case (.bishop,_):
            return  bishopQayl(to: to)
            
        case (.queen,_):
            
            return bishopQayl(to: to) || rookQayl(to: to)
            
        case (.king,let type):
            if type == .black {
                return kingQayl(to: to, type: .black)
            }else {
                return kingQayl(to: to, type: .white)
            }
            
            
        default:
            break
        }
        return false
    }
    
    
    func kingQayl(to:(Int,Int),type:PlayerType) -> Bool {
        if col == to.0 {
            return abs(row - to.1) == 1
        }
        if row == to.1 {
            return abs(col - to.0) == 1
        }
        if abs(col - to.0) == abs(row - to.1) {
            return abs(col - to.0) == 1 && abs(row - to.1) == 1
        }
        //        qareriDasht[to.0][to.1] = (.pown,type)
        return  false
    }
    
    private func dziuQayl(to:(Int,Int)) -> Bool{
        return   (abs(row - to.1) == 2 && abs(col - to.0) == 1) || (abs(col - to.0) == 2 && abs(row - to.1) == 1)
    }
    
    func pawnQaylSev(to:(Int,Int)) -> Bool {
        if col != to.0 {
            return false
        }
        return row == 6 ? row - to.1 < 3 : row - to.1 == 1
    }
    
    func pawnQaylSpitak(to:(Int,Int)) -> Bool {
        if col != to.0 {
            return false
        }
        return row == 1 ? row + to.1 < 5 : (row - to.1) == -1
    }
    
    func rookQayl(to:(Int,Int)) -> Bool {
        if col == to.0 {
            return abs(row - to.1) < 8
        }
        if row == to.1 {
            return abs(col - to.0) < 8
        }
        return false
    }
    
    func bishopQayl(to:(Int,Int)) -> Bool {
        return abs(col - to.0) == abs(row - to.1)
    }
    
    func jnjiImageView (imageView:Xaxaqar,to:(Int,Int)) {
        if imageView.col == to.1 && imageView.row == to.0  {
            imageView.removeFromSuperview()
        }
    }
    
}
