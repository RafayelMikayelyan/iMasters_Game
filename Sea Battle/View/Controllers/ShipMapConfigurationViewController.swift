//
//  ShipMapConfigurationViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 19.09.23.
//


import UIKit
import Lottie
import MultipeerConnectivity

extension CGRect {
    var tail: CGPoint { // tail introduced because when gesture location we pass to origin frame layed under the finger and become unvisible
        get {
            return CGPoint(x: self.origin.x + self.width, y: self.origin.y + self.height)
        }
        set {
            self.origin = CGPoint(x:newValue.x - self.width,y:newValue.y - self.height)
        }
    }
}

final class ShipMapConfigurationViewController: UIViewController {
        
    private var appendedImage: ImageViewWithShipIdetifier = ImageViewWithShipIdetifier()
    
    private let longPressGestureForMovingShip: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = 0.3
        return gesture
    }()
    private let longPressGestureForMovingShipOnMap: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = 0.8
        return gesture
    }()
    
    private let doubleTapToRotateOnMapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()
    
    private let viewModel:ViewModelForMapAndShips = ViewModelForMapAndShips()
    
    private let absoluteHeightsForAllSectionsHeaders:CGFloat = 28
    
    private let absolutheHeightForAllSectionsFooters:CGFloat = 3
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ShipsMapsBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let shipsMapCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let errorMessageView: ErrorMessageView = {
        let view = ErrorMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var inviteBanner = InviteBannerView()
    
    private let blurWithBanner: UIVisualEffectView = {
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effect.alpha = 0
        effect.isUserInteractionEnabled = false
        effect.translatesAutoresizingMaskIntoConstraints = false
        return effect
    }()
    
    private var animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "timeLoader")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 1.8
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.alpha = 0
        return animation
    }()
    
    private var sendingLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.text = "Data Sending"
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.view.backgroundColor = .white
        self.navigationBarDisablier()
        
        configuiringWithSectionLayout()
        
        collectionViewRegistering()
        
        shipsMapCollectionView.addGestureRecognizer(longPressGestureForMovingShipOnMap)
        shipsMapCollectionView.addGestureRecognizer(longPressGestureForMovingShip)
        shipsMapCollectionView.addGestureRecognizer(doubleTapToRotateOnMapGesture)
                                
        self.longPressGestureForMovingShip.delegate = self
        self.longPressGestureForMovingShipOnMap.delegate = self
        self.doubleTapToRotateOnMapGesture.delegate = self
        
        self.longPressGestureForMovingShip.addTarget(self, action: #selector(longPressGestureSelectorForSectionTwo))
        self.longPressGestureForMovingShipOnMap.addTarget(self, action: #selector(longPressGestureSelectorForMap))
        self.doubleTapToRotateOnMapGesture.addTarget(self, action: #selector(doubleTapToRotateGestureSelector))
        
        shipsMapCollectionView.dataSource = self
        shipsMapCollectionView.delegate = self
        
        view.addSubview(backgroundImage)
        view.addSubview(shipsMapCollectionView)
        view.addSubview(animationView)
        view.addSubview(sendingLabel)

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            shipsMapCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            shipsMapCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            shipsMapCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            shipsMapCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            animationView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            sendingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendingLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor)
        ])
        
        configuireWithViewModel()
        
    }
    
    private func navigationBarDisablier() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func configuireWithViewModel() {
        
        self.viewModel.functionalityWhenShipsSectionDataProvided = { [weak self] in
            guard let self else {return}
            self.shipsMapCollectionView.reloadData()//if i reload only section two animation always bring me to start on section two
        }
        
        self.viewModel.functionalityWhenMapSectionDataProvided = { [weak self] in
            guard let self else {return}
            self.shipsMapCollectionView.reloadData()
        }
        
        self.viewModel.functionalityWhenShipsCountAdded = { [weak self] in
            guard let self else {return}
            self.shipsMapCollectionView.removeGestureRecognizer(self.longPressGestureForMovingShip)
        }
        self.viewModel.getShipsDataModel()
        self.viewModel.getMapDataModel()
        self.viewModel.setMultipeerConectivityHandler(with :DataAboutPlayerSingleton.shared.providePlayerName())
        self.viewModel.setTimertarget()
        self.viewModel.setFunctionalityWhenConnectionEstablished { [weak self] data in
            guard let self else {return}
            DispatchQueue.main.asyncAfter(deadline:.now() + 4,qos:.userInteractive) {
//                self.viewModel.stopMCAdvertiserAdvertising() // I dont care about case when i in game and new player invite me to his game in my UI I dont see invite banner so after 30 seconds invitation will be authomatically cancelled!!!!!
                self.viewModel.resetBrowser()
                let battleViewController = BattleViewController()
                if self.viewModel.provideButtonType() == .join {
                    battleViewController.setViewModel(with: ViewModelForBattleViewController(dataModel: DataSourceForBattleViewController(dataForSelfMapSection: self.viewModel.provideDataForSelfMapOnBattle()), opponentPlayer: data, connectorStatus: .joiner), conectivityHandler: self.viewModel.provideConnectivityHandler(), playingStatus: .canNotPlay)
                } else {
                    battleViewController.setViewModel(with: ViewModelForBattleViewController(dataModel: DataSourceForBattleViewController(dataForSelfMapSection: self.viewModel.provideDataForSelfMapOnBattle()), opponentPlayer: data, connectorStatus: .starter), conectivityHandler: self.viewModel.provideConnectivityHandler(), playingStatus: .canPlay)
                }
                UIView.animate(withDuration: 0.1) {
                    self.animationView.stop()
                    self.animationView.alpha = 0
                    self.sendingLabel.alpha = 0
                }
                self.show(battleViewController, sender: nil)
            }
        }
        
        self.viewModel.setFunctionalityWhenConnectionProvided { [weak self] data in
            guard let self else {return}
            self.viewModel.enterInovationToMultipeerConnectivity()
            self.inviteBanner = InviteBannerView()
            self.inviteBanner.setTargetToGetButton(self.viewModel)
            self.inviteBanner.setTargetToCancelButton(self.viewModel)
            self.inviteBanner.setBannerPlayerIconName(with: data)
            self.view.addSubview(self.blurWithBanner)
            self.view.addSubview(self.inviteBanner)
            NSLayoutConstraint.activate([
                self.blurWithBanner.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.blurWithBanner.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                self.blurWithBanner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.blurWithBanner.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            ])
            self.inviteBanner.frame = CGRect(x: 0, y: -self.view.bounds.height*0.15, width: self.view.bounds.width, height: self.view.bounds.height*0.15)
            UIView.animate(withDuration: 0.5) {
                self.blurWithBanner.alpha = 0.8
                self.inviteBanner.frame.origin = self.shipsMapCollectionView.frame.origin
            }
        }
        
        self.viewModel.functionalityWhenInviteBannerResponse = { [weak self] isGetted in
            guard let self else {return}
            UIView.animate(withDuration: 0.5) {
                self.blurWithBanner.alpha = 0
                self.inviteBanner.frame.origin = CGPoint(x: 0, y: -self.view.bounds.height*0.15)
                self.inviteBanner.removeFromSuperview()
            }
            if isGetted {
                UIView.animate(withDuration: 0.3) {
                    self.shipsMapCollectionView.isUserInteractionEnabled = false
                    self.animationView.alpha = 1
                    self.sendingLabel.alpha = 1
                    self.animationView.play()
                }
            }
        }
        
        self.viewModel.functionalityForStartButton = { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async(qos:.userInteractive) {
                if self.viewModel.givenConnectionStatus == .connected {
                    self.viewModel.startBrowsingOfMCBrowser()
                    let vc = MultiplayerConnectivityBrowserViewController()
                    vc.delegate = self.viewModel
                    vc.modalPresentationStyle = .pageSheet
                    vc.setViewModelMultipeerConectivityHandler(with: self.viewModel.provideConnectivityHandler())
                    self.present(vc, animated: true)
                } else {
                    let alertAboutConnection = UIAlertController(title: "Connection to WI-Fi missing", message: "Please check your connection to WI-Fi or Personal Hotspot to connect with other player.", preferredStyle: .alert)
                    alertAboutConnection.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    alertAboutConnection.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
                            return
                        }
                        UIApplication.shared.open(url)
                    }))
                    self.present(alertAboutConnection,animated: true)
                }
            }
        }
        
        self.viewModel.functionalityForJoinButton = { [weak self] in 
            guard let self else {return}
            DispatchQueue.main.async(qos: .userInteractive) {
                if self.viewModel.givenConnectionStatus == .connected {
                    self.viewModel.setUpWithMultipeerConectivityJoinerDelegate()
                    self.viewModel.startMCAdvertiserAdvertising()
                } else {
                    let alertAboutConnection = UIAlertController(title: "Connection to WI-Fi missing", message: "Please check your connection to WI-Fi or Personal Hotspot to connect with other player.", preferredStyle: .alert)
                    alertAboutConnection.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    alertAboutConnection.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
                            return
                        }
                        UIApplication.shared.open(url)
                    }))
                    self.present(alertAboutConnection,animated: true)
                }
            }
        }
        
        self.viewModel.functionalityWhenEstablisherChangesToTrue = { [weak self] in
            guard let self else {return}
            UIView.animate(withDuration: 0.3) {
                self.animationView.alpha = 1
                self.sendingLabel.alpha = 1
                self.animationView.play()
            }
        }
        
        self.viewModel.functionalityWhenConnectioStatusChanged = { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async(qos: .userInteractive) {
                self.sendingLabel.text = "Connection Lost"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5,qos: .userInteractive) {
                    UIView.animate(withDuration: 0.5) {
                        self.animationView.alpha = 0
                        self.sendingLabel.alpha = 0
                        self.animationView.stop()
                    }
                    self.shipsMapCollectionView.isUserInteractionEnabled = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.sendingLabel.text = "Data Sending"
                    }
                }
            }
        }
    }
    
    @objc private func longPressGestureSelectorForSectionTwo(_ sender: UILongPressGestureRecognizer) {
        whenGestureStateIsBegun(sender: sender,for: 2)
        if sender.state == .changed {
            whenGestureStateIsChanged(sender: sender)
        }
        if sender.state == .ended {
            whenGestureStateIsEnded(sender: sender, for: 2)
        }
    }
    
    @objc private func longPressGestureSelectorForMap(_ sender: UILongPressGestureRecognizer) {
        whenGestureStateIsBegun(sender: sender,for: 1)
        if sender.state == .changed {
            whenGestureStateIsChanged(sender: sender)
        }
        if sender.state == .ended {
            whenGestureStateIsEnded(sender: sender, for: 1)
        }
    }
    
    private func whenGestureStateIsBegun(sender: UILongPressGestureRecognizer,for section: Int) {
        let indexPath = shipsMapCollectionView.indexPathForItem(at: sender.location(in: shipsMapCollectionView))
        guard let indexPath,indexPath.section == section else {return}
        if section == 2 {
            let cell = shipsMapCollectionView.cellForItem(at: indexPath) as? ShipsCell
            guard let cell, cell.isContainsShip() else {return}
            self.viewModel.prepareToRemoveShip(on: indexPath)
            let imageView = ImageViewWithShipIdetifier()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named:cell.provideSelfShipIndentificator().rawValue)
            imageView.setImageIdentifier(with: cell.provideSelfShipIndentificator())
            let cellMeasure = (self.shipsMapCollectionView.bounds.height/10)*5.3/11
            switch cell.provideSelfShipIndentificator() {
            case .oneCellShip:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure)
            case .twoCellShip:
                imageView.frame.size = CGSize(width: cellMeasure*2, height: cellMeasure)
            case .threeCellShip:
                imageView.frame.size = CGSize(width: cellMeasure*3, height: cellMeasure)
            case .fourCellShip:
                imageView.frame.size = CGSize(width: cellMeasure*4, height: cellMeasure)
            case .oneCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure)
            case .twoCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure*2)
            case .threeCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure*3)
            case .fourCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure*4)
            }
            if sender.state == .began {
                self.appendedImage = imageView
                self.view.addSubview(appendedImage)
                self.appendedImage.frame.tail = sender.location(in: self.view)
            }
        } else {
            let cell = shipsMapCollectionView.cellForItem(at: indexPath) as? CellForMapAndShips
            guard let cell,let identificator = cell.provideSelfShipIndentificator() else {return}
            let imageView = ImageViewWithShipIdetifier()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named:identificator.rawValue)
            imageView.setImageIdentifier(with: identificator)
            let cellMeasure = (self.shipsMapCollectionView.bounds.height/10)*5.3/11
            switch identificator {
            case .oneCellShip:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure)
            case .twoCellShip:
                imageView.frame.size = CGSize(width: cellMeasure*2, height: cellMeasure)
            case .threeCellShip:
                imageView.frame.size = CGSize(width: cellMeasure*3, height: cellMeasure)
            case .fourCellShip:
                imageView.frame.size = CGSize(width: cellMeasure*4, height: cellMeasure)
            case .oneCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure)
            case .twoCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure*2)
            case .threeCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure*3)
            case .fourCellShipRotated:
                imageView.frame.size = CGSize(width: cellMeasure, height: cellMeasure*4)
            }
            if sender.state == .began {
                self.viewModel.changeDataBy(index: indexPath.item)
                self.appendedImage = imageView
                self.view.addSubview(appendedImage)
                self.appendedImage.frame.tail = sender.location(in: self.view)
            }
        }
    }
    
    private func highlightMapsCell(with color: HighlightColor) {
        switch color {
        case .red:
            for i in self.viewModel.setOfIndexPathsForHighlighting {
                let cell = self.shipsMapCollectionView.cellForItem(at: i) as? CellForMapAndShips
                if let cell {
                    cell.highlightCellWithRedBackground()
                }
            }
        case .green:
            for i in self.viewModel.setOfIndexPathsForHighlighting {
                let cell = self.shipsMapCollectionView.cellForItem(at: i) as? CellForMapAndShips
                if let cell {
                    cell.highlightCellWithGreenBackground()
                }
            }
        case .fixed:
            for i in self.viewModel.setOfIndexPathsForHighlighting {
                let cell = self.shipsMapCollectionView.cellForItem(at: i) as? CellForMapAndShips
                if let cell {
                    cell.fixCellBackground()
                }
            }
        }
    }
    
    private func whenGestureStateIsChanged(sender: UILongPressGestureRecognizer) {
        self.appendedImage.frame.tail = sender.location(in: self.view)
        self.highlightMapsCell(with: .fixed)
        
        let cellMeasure = (self.shipsMapCollectionView.bounds.height/10)*5.3/11
        let maxIndexPath = self.shipsMapCollectionView.indexPathForItem(at:CGPoint(x:sender.location(in: self.shipsMapCollectionView).x - cellMeasure/2, y:sender.location(in: self.shipsMapCollectionView).y - cellMeasure/2))
        let minIndexPath = self.shipsMapCollectionView.indexPathForItem(at: CGPoint(x: sender.location(in: self.shipsMapCollectionView).x - self.appendedImage.bounds.width + cellMeasure/2, y: sender.location(in: self.shipsMapCollectionView).y - self.appendedImage.bounds.height + cellMeasure/2))
        let pointChecker: CGFloat = self.appendedImage.frame.origin.x + self.appendedImage.bounds.width
        
        if let maxIndexPath, let minIndexPath, minIndexPath.section == 1 && maxIndexPath.section == 1 && maxIndexPath.item % 11 != 0 && maxIndexPath.item / 10 != 0 && self.appendedImage.getImageIdentifier() != nil && pointChecker <= self.view.bounds.width {
            if let cell = self.shipsMapCollectionView.cellForItem(at: maxIndexPath) as? CellForMapAndShips, let cellTwo = self.shipsMapCollectionView.cellForItem(at: minIndexPath) as? CellForMapAndShips, !(cell.isCellContainedItem()) && !(cellTwo.isCellContainedItem())  {
                self.viewModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: self.appendedImage.getImageIdentifier()!)
                self.highlightMapsCell(with: .green)
            } else {
                self.viewModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: self.appendedImage.getImageIdentifier()!)
                self.highlightMapsCell(with: .red)
            }
        }  else {return}
    }
    
    private func whenGestureStateIsEnded(sender: UILongPressGestureRecognizer, for section: Int) {
        highlightMapsCell(with: .fixed)
        let cellMeasure = (self.shipsMapCollectionView.bounds.height/10)*5.3/11
        let maxIndexPath = self.shipsMapCollectionView.indexPathForItem(at:CGPoint(x:sender.location(in: self.shipsMapCollectionView).x - cellMeasure/2, y:sender.location(in: self.shipsMapCollectionView).y - cellMeasure/2))
        let minIndexPath = self.shipsMapCollectionView.indexPathForItem(at: CGPoint(x: sender.location(in: self.shipsMapCollectionView).x - self.appendedImage.bounds.width + cellMeasure/2, y: sender.location(in: self.shipsMapCollectionView).y - self.appendedImage.bounds.height + cellMeasure/2))
        guard let maxIndexPath, let minIndexPath else {
            if section == 1 {
                self.viewModel.restoreData()
            }
            self.viewModel.resetSetOfindexPaths()
            self.appendedImage.alpha = 0
            self.appendedImage = ImageViewWithShipIdetifier()
            self.appendedImage.removeFromSuperview()
            return
        }
        if let minCell = (self.shipsMapCollectionView.cellForItem(at: maxIndexPath) as? CellForMapAndShips), let maxCell = (self.shipsMapCollectionView.cellForItem(at: minIndexPath) as? CellForMapAndShips), !minCell.isCellContainedItem() && !maxCell.isCellContainedItem() && self.appendedImage.getImageIdentifier() != nil {
            if sender === self.longPressGestureForMovingShip && section == 2 {
                self.viewModel.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: self.appendedImage.getImageIdentifier()!, in: true)
            }
            if sender === self.longPressGestureForMovingShipOnMap && section == 1 {
                self.viewModel.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: self.appendedImage.getImageIdentifier()!, in: false)
            }
        }
        if section == 1 {
            self.viewModel.restoreData()
        }
        self.viewModel.resetSetOfindexPaths()
        self.appendedImage.alpha = 0
        self.appendedImage = ImageViewWithShipIdetifier()
        self.appendedImage.removeFromSuperview()
    }
    
    @objc private func doubleTapToRotateGestureSelector(_ sender: UITapGestureRecognizer) {
        let indexPath = self.shipsMapCollectionView.indexPathForItem(at: sender.location(in: self.shipsMapCollectionView))
        guard let indexPath, indexPath.section == 1 else {return}
        guard let cell = self.shipsMapCollectionView.cellForItem(at: indexPath) as? CellForMapAndShips, let shipIdentifier = cell.provideSelfShipIndentificator() else {return}
        self.viewModel.performRotation(on: indexPath, with: shipIdentifier)
    }
    
    private func errorThrowWhenMapIsNotSetted(sender: UIButton) {
        sender.isEnabled = false
        self.view.addSubview(errorMessageView)
        NSLayoutConstraint.activate([
            self.errorMessageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.errorMessageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        UIView.animate(withDuration: 0.2) {
            self.errorMessageView.alpha = 0
            self.errorMessageView.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIView.animate(withDuration: 0.3) {
                self.errorMessageView.alpha = 1
                self.errorMessageView.alpha = 0
                self.errorMessageView.removeFromSuperview()
            }
            sender.isEnabled = true
        }
    }
    
    @objc func startBattleButtonTapSelector(_ sender: UIButton) {
        if self.viewModel.isFullMapSetted() {
            DataAboutPlayerSingleton.shared.setPlayer(with: self.viewModel.provideDataForSelfMapOnBattle())
            self.viewModel.setButtonType(with: .start)
            self.viewModel.setDelegateToNetworkManager()
        } else {
            errorThrowWhenMapIsNotSetted(sender: sender)
        }
    }
    
    @objc func joinBattleButtonTapSelector(_ sender: UIButton) {
        if self.viewModel.isFullMapSetted() {
            DataAboutPlayerSingleton.shared.setPlayer(with: self.viewModel.provideDataForSelfMapOnBattle())
            self.viewModel.setButtonType(with: .join)
            self.viewModel.setDelegateToNetworkManager()
        } else {
            errorThrowWhenMapIsNotSetted(sender: sender)
        }
    }
    
    private func configuiringWithSectionLayout() {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex,enviroment in
            switch sectionIndex {
            case 0:
                let section =  self!.layoutConfigurationForMapAndShipSections(for: 0)
                section!.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "mapDecor")]
                section!.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(self!.absoluteHeightsForAllSectionsHeaders)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading),NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(self!.absolutheHeightForAllSectionsFooters)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomLeading)]
                return section
            case 1 :
                let section =  self!.layoutConfigurationForMapAndShipSections(for: 1)
                section!.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "mapDecor")]
                section!.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(self!.absoluteHeightsForAllSectionsHeaders)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading),NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(self!.absolutheHeightForAllSectionsFooters)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomLeading)]
                return section
            case 2:
                let section = self!.layoutConfigurationForMapAndShipSections(for: 2)
                section!.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "mapDecor")]
                section!.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(self!.absoluteHeightsForAllSectionsHeaders)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading),NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .absolute(self!.absolutheHeightForAllSectionsFooters+5)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomLeading)]
                return section
            default:
                return nil
            }
        }
        layout.register(DecorationViewForMapAndShips.self, forDecorationViewOfKind: "mapDecor")
        let configForLayout = UICollectionViewCompositionalLayoutConfiguration()
        configForLayout.interSectionSpacing = 10
        layout.configuration = configForLayout
        self.shipsMapCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func layoutConfigurationForMapAndShipSections(for section: Int) -> NSCollectionLayoutSection? {
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.3/10)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/11), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.5, bottom: 0, trailing:0.5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/11)), repeatingSubitem: item, count: 11)
            let collectionGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute((self.shipsMapCollectionView.bounds.height/10)*5.3), heightDimension: .fractionalHeight(5.3/10)), repeatingSubitem: group, count: 11)
            let section = NSCollectionLayoutSection(group: collectionGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: (self.view.bounds.width - (self.shipsMapCollectionView.bounds.height/10)*5.3)/2, bottom: 5, trailing: (self.view.bounds.width - (self.shipsMapCollectionView.bounds.height/10)*5.3)/2)
            section.orthogonalScrollingBehavior = .none
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top:0, leading: 5, bottom: 0, trailing: 5)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1/10)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            return section
        default:
            break
        }
        return nil
    }
}

extension ShipMapConfigurationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return self.viewModel.givenDataForMap.count
        } else {
            return self.viewModel.givenDataOfShips.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = self.shipsMapCollectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! PlayerCell
            cell.configuireAutoButtonTarget(target: self.viewModel)
            cell.configuireStartBattleButtonTarget(target: self)
            cell.configuireJoinBattleButtonTarget(target: self)
            return cell
        }
        if indexPath.section == 1 {
            if !(["","A","B","C","D","E","F","G","H","I","J","1","2","3","4","5","6","7","8","9","10"].contains(self.viewModel.givenDataForMap[indexPath.item])) {
                let cell = self.shipsMapCollectionView.dequeueReusableCell(withReuseIdentifier: "cellMap", for: indexPath) as! CellForMapAndShips
                if self.viewModel.givenDataForMap[indexPath.item] == "mappCelll" {
                    cell.configuire(with: self.viewModel.givenDataForMap[indexPath.item])
                } else {
                    cell.configuireByContained(with: self.viewModel.givenDataForMap[indexPath.item])
                }
                return cell
            }else{
                let cell = self.shipsMapCollectionView.dequeueReusableCell(withReuseIdentifier: "colRowIndentificatorCell", for: indexPath) as! MapColumnOrRowCell
                cell.configuire(with: self.viewModel.givenDataForMap[indexPath.item])
                return cell
            }
        }
        
        if indexPath.section == 2 {
            let cell = self.shipsMapCollectionView.dequeueReusableCell(withReuseIdentifier: "cellShip", for: indexPath) as! ShipsCell
            cell.configuire(with: self.self.viewModel.givenDataOfShips[indexPath.item] )
            return cell
        }
        
        return UICollectionViewCell.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = self.shipsMapCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerMap", for: indexPath) as! MapPlayerSectionHeaderView
            if indexPath.section == 0 {
                header.configuire(with: "Player")
            }
            if indexPath.section == 1 {
                header.configuire(with: "Map")
            }
            if indexPath.section == 2 {
                let headerForShipsSection = self.shipsMapCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "shipHeader", for: indexPath) as! ShipsSectionHeader
                headerForShipsSection.rotateLeftButtonHandler = UIAction(handler: { [weak self] _ in
                    self?.viewModel.getShipsDataModel()
                })
                headerForShipsSection.rotateRightButtonHandler = UIAction(handler: { [weak self] _ in
                    self?.viewModel.getShipsDataModelRotated()
                })
                headerForShipsSection.configuire(with: "Ships")
                return headerForShipsSection
            }
            return header
        }
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = self.shipsMapCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "mapFooter", for: indexPath) as! MapShipsFooterView
            return footer
        }
        return UICollectionReusableView.init()
    }
    
    func collectionViewRegistering() {
        shipsMapCollectionView.register(CellForMapAndShips.self, forCellWithReuseIdentifier: "cellMap")
        shipsMapCollectionView.register(ShipsCell.self, forCellWithReuseIdentifier: "cellShip")
        shipsMapCollectionView.register(PlayerCell.self, forCellWithReuseIdentifier: "playerCell")
        shipsMapCollectionView.register(MapPlayerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerMap")
        shipsMapCollectionView.register(ShipsSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "shipHeader")
        shipsMapCollectionView.register(MapShipsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "mapFooter")
        shipsMapCollectionView.register(MapColumnOrRowCell.self, forCellWithReuseIdentifier: "colRowIndentificatorCell")
    }
}

extension ShipMapConfigurationViewController: UICollectionViewDelegate {}

extension ShipMapConfigurationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.longPressGestureForMovingShip && otherGestureRecognizer === self.longPressGestureForMovingShipOnMap {
            return true
        }
        return false
    }
}

extension ShipMapConfigurationViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
      //
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true)
        browserViewController.browser?.stopBrowsingForPeers()
    }
}
