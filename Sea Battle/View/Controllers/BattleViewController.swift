//
//  BattleViewController.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 26.09.23.
//

import UIKit

final class BattleViewController: UIViewController {
    
    private var viewModel: ViewModelForBattleViewController!
    
    private let absoluteHeightsForAllSectionsHeaders:CGFloat = 28
    
    private let absolutheHeightForAllSectionsFooters:CGFloat = 5
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "ShipsMapsBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playerMapCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        navigationBarDisablier()
        
        configuiringWithSectionLayout()
        
        collectionViewRegistering()
        
        self.view.addSubview(backgroundImage)
        self.view.addSubview(playerMapCollectionView)
        
        self.playerMapCollectionView.dataSource = self
        self.playerMapCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerMapCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerMapCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            playerMapCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerMapCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        configuireViewModel()
    }
    
    private func configuiringWithSectionLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionNumber, environment in
            switch sectionNumber {
            case 0:
                let section = self.layoutConfigurationForMapAndShipSections(for: 0)
                section?.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "mapDecor")]
                section?.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(5)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)]
                return section
            case 1:
                let section = self.layoutConfigurationForMapAndShipSections(for: 1)
                section?.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "mapDecor")]
                section?.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(5)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)]
                return section
            case 2:
                let section = self.layoutConfigurationForMapAndShipSections(for: 2)
                section?.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: "mapDecor")]
                section?.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top),NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(5)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)]
                return section
            default:
                break
            }
            return nil
        }
        layout.register(DecorationViewForMapAndShips.self, forDecorationViewOfKind: "mapDecor")
        let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfiguration.interSectionSpacing = 10
        layout.configuration = layoutConfiguration
        self.playerMapCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func layoutConfigurationForMapAndShipSections(for section: Int) -> NSCollectionLayoutSection? {
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/10)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .none
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/11), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.3, leading: 0.3, bottom: 0.3, trailing: 0.3)
            let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/11)), repeatingSubitem: item, count: 11)
            innerGroup.interItemSpacing = .fixed(0)
            let collectiveGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute((self.playerMapCollectionView.bounds.height/10)*3), heightDimension: .fractionalHeight(3/10)), repeatingSubitem: innerGroup,count: 11)
            let section = NSCollectionLayoutSection(group: collectiveGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: (self.view.bounds.width - (self.playerMapCollectionView.bounds.height/10)*3)/2, bottom: 0, trailing: (self.view.bounds.width - (self.playerMapCollectionView.bounds.height/10)*3)/2)
            section.orthogonalScrollingBehavior = .none
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/11), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0.3, leading: 0.3, bottom: 0.3, trailing: 0.3)
            let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/11)), repeatingSubitem: item, count: 11)
            innerGroup.interItemSpacing = .fixed(0)
            let collectiveGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute((self.playerMapCollectionView.bounds.height/10)*4), heightDimension: .fractionalHeight(4/10)), repeatingSubitem: innerGroup,count: 11)
            let section = NSCollectionLayoutSection(group: collectiveGroup)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: (self.view.bounds.width - (self.playerMapCollectionView.bounds.height/10)*4)/2, bottom: 0, trailing: (self.view.bounds.width - (self.playerMapCollectionView.bounds.height/10)*4)/2)
            section.orthogonalScrollingBehavior = .none
            return section
        default:
            break
        }
        return nil
    }

    
    private func navigationBarDisablier() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setViewModel(with viewModel: ViewModelForBattleViewController, conectivityHandler: MultiplayerConectionAsMPCHandler) {
        self.viewModel = viewModel
        self.viewModel.setMultipeerConnectivityHandler(with: conectivityHandler)
    }
    
    private func configuireViewModel() {
        self.viewModel.functionalityWhenDataForSelfMapProvided = {
            self.playerMapCollectionView.reloadData()
        }
        self.viewModel.functionalityWhenDataForSelfMapProvided = {
            self.playerMapCollectionView.reloadData()
        }
        self.viewModel.getDataForSelfMap()
        self.viewModel.getDataForOpponentMap()
    }
    
}

extension BattleViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return self.viewModel.providedDataForSelfMapSection.count
        } else {
            return self.viewModel.providedDataForOpponentMapSection.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = self.playerMapCollectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! PlayerCellForBattleViewController
            return cell
        } else if indexPath.section == 1 {
            if !(["","A","B","C","D","E","F","G","H","I","J","1","2","3","4","5","6","7","8","9","10"].contains(self.viewModel.providedDataForSelfMapSection[indexPath.item])) {
                let cell = self.playerMapCollectionView.dequeueReusableCell(withReuseIdentifier: "cellMap", for: indexPath) as! CellForMapAndShips
                if self.viewModel.providedDataForSelfMapSection[indexPath.item] == "mappCelll" {
                    cell.configuire(with: self.viewModel.providedDataForSelfMapSection[indexPath.item])
                } else {
                    cell.configuireByContained(with: self.viewModel.providedDataForSelfMapSection[indexPath.item])
                }
                return cell
            } else {
                let cell = self.playerMapCollectionView.dequeueReusableCell(withReuseIdentifier: "colRowIndentificatorCell", for: indexPath) as! MapColumnOrRowCell
                cell.configuire(with: self.viewModel.providedDataForSelfMapSection[indexPath.item])
                return cell
            }
        } else {
            if !(["","A","B","C","D","E","F","G","H","I","J","1","2","3","4","5","6","7","8","9","10"].contains(self.viewModel.providedDataForOpponentMapSection[indexPath.item])) {
                let cell = self.playerMapCollectionView.dequeueReusableCell(withReuseIdentifier: "cellMap", for: indexPath) as! CellForMapAndShips
                if self.viewModel.providedDataForOpponentMapSection[indexPath.item] == "mappCelll" {
                    cell.configuire(with: self.viewModel.providedDataForOpponentMapSection[indexPath.item])
                } else {
                    cell.configuireByContained(with: self.viewModel.providedDataForOpponentMapSection[indexPath.item])
                }
                return cell
            } else {
                let cell = self.playerMapCollectionView.dequeueReusableCell(withReuseIdentifier: "colRowIndentificatorCell", for: indexPath) as! MapColumnOrRowCell
                cell.configuire(with: self.viewModel.providedDataForOpponentMapSection[indexPath.item])
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = self.playerMapCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerMap", for: indexPath) as! MapPlayerSectionHeaderView
            if indexPath.section == 0 {
                header.configuire(with: "Players")
            }
            if indexPath.section == 1 {
                header.configuire(with: "Map")
            }
            if indexPath.section == 2 {
                header.configuire(with: "Oponent's map")
            }
            return header
        }
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = self.playerMapCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "mapFooter", for: indexPath) as! MapShipsFooterView
            return footer
        }
        return UICollectionReusableView.init()
    }
    
    func collectionViewRegistering() {
        playerMapCollectionView.register(CellForMapAndShips.self, forCellWithReuseIdentifier: "cellMap")
        playerMapCollectionView.register(PlayerCellForBattleViewController.self, forCellWithReuseIdentifier: "playerCell")
        playerMapCollectionView.register(MapPlayerSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerMap")
        playerMapCollectionView.register(MapShipsFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "mapFooter")
        playerMapCollectionView.register(MapColumnOrRowCell.self, forCellWithReuseIdentifier: "colRowIndentificatorCell")
    }
}

extension BattleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.sendData(data: indexPath.debugDescription.data(using: .utf8))
    }
}
