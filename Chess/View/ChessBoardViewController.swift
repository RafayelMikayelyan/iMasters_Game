//
//  ViewController.swift
//  miViewTexadrelMyusiMej
//
//  Created by Saq on 12/11/20.
//  Copyright © 2020 Saq. All rights reserved.

import UIKit

class ChessBoardViewController: UIViewController {
    
    
    let backGroundView = BackGroundView()
    let cellView = CellView()
    let col:CGFloat = 8
    let row:CGFloat = 8
    let bordeWidth:CGFloat = 2
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backGroundView)
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.backgroundColor = .gray
        addCellView(view: backGroundView)
        
        NSLayoutConstraint.activate([
            backGroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backGroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backGroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.1),
            backGroundView.heightAnchor.constraint(equalTo: backGroundView.widthAnchor) // Maintain aspect ratio
                ])
       
    }
    
    func addCellView(view:UIView) {
        jnjiView(view: view)
        let viewWidth = view.bounds.width / col
        let viewHeight = view.bounds.height / row
        for tox in 0..<Int(row) {
            for syun in 0..<Int(col) {
//                let viewFrame = CGRect(x: 0 , y: 0, width: viewWidth, height: viewHeight)
                
                let avelacvoxView = UIView()
                avelacvoxView.translatesAutoresizingMaskIntoConstraints = false
                avelacvoxView.layer.borderWidth = CGFloat(bordeWidth)
                avelacvoxView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                avelacvoxView.backgroundColor = ((syun + tox) % 2) == 0 ? #colorLiteral(red: 0.5056313452, green: 0.4581978993, blue: 0.3308045929, alpha: 1) : #colorLiteral(red: 1, green: 0.9257106548, blue: 0.8345380365, alpha: 1)
                view.addSubview(avelacvoxView)
                NSLayoutConstraint.activate([
                    avelacvoxView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
                    avelacvoxView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
                    avelacvoxView.heightAnchor.constraint(equalToConstant:viewHeight ),
                    avelacvoxView.widthAnchor.constraint(equalToConstant:viewWidth )
                    
                        ])
               
                
                
//                avelacvoxView.center = veradardzruMiQarakusuKentrony(view: view, syun: syun, tox: tox)
                
                
            }
        }
    }
    
    func veradardzruMiQarakusuKentrony(view:UIView, syun:Int,tox:Int) -> (CGPoint) {
        let dasckiMijiQarakusuWidth = view.bounds.width / col
        let dasckiMijiQarakusuHeight = view.bounds.height / row
        let x = (CGFloat(syun) * dasckiMijiQarakusuWidth) + (dasckiMijiQarakusuWidth / 2)
        let y = (CGFloat(tox) * dasckiMijiQarakusuHeight) + (dasckiMijiQarakusuHeight / 2)
        return CGPoint(x: x, y: y)
    }
    
    func jnjiView(view:UIView) {
        let arrayView = view.subviews
        for i in arrayView {
            i.removeFromSuperview()
        }
    }
    
    
    
//    private let colectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    
//    override func viewDidLoad() {
//      super.viewDidLoad()
//        colectionView.delegate = self
//        colectionView.dataSource = self
//      let deviceWidth = UIScreen.main.bounds.size.width
//      let cellWidth = floor(deviceWidth / 8)
//      let collectionViewWidth = 8 * cellWidth
//      self.collectionViewWidthConstraint.constant = collectionViewWidth
//
//  }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//       let deviceWidth = UIScreen.main.bounds.size.width
//       let width = floor(deviceWidth / 8)
//       let height = width
//       return CGSize(width: width, height: height)
//   }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//             return  64
//        }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "unique", for: indexPath)
//
//            let chessRow = indexPath.row / 8
//            if chessRow % 2 == 0 {
//                if indexPath.row % 2 == 0 {
//                     cell.backgroundColor = UIColor.white
//                }else{
//                    cell.backgroundColor = UIColor.black
//                }
//            } else{
//                if indexPath.row % 2 == 0 {
//                    cell.backgroundColor = UIColor.black
//                }else{
//                    cell.backgroundColor = UIColor.white
//                }
//            }
//
//            return cell
//        }
    
    
    
}
