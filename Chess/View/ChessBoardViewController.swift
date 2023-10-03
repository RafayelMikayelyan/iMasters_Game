//
//  ChessBoardViewController.swift
//  Sea Battle
//
//  Created by Rafayel on 28.09.23.
//

import UIKit

final class ChessBoardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        let chessboard = ChessboardView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        view.addSubview(chessboard)
    }
    

}
class ChessboardView: UIView {
    // Implement the chessboard UI and interactions here
}



