//
//  ChessModel.swift
//  Sea Battle
//
//  Created by Rafayel on 01.10.23.
//

import Foundation

enum ChessPieceType {
    case pawn, rook, knight, bishop, queen, king
}

enum ChessPieceColor {
    case white, black
}

class ChessPiece {
    var type: ChessPieceType
    var color: ChessPieceColor

    init(type: ChessPieceType, color: ChessPieceColor) {
        self.type = type
        self.color = color
    }
}


