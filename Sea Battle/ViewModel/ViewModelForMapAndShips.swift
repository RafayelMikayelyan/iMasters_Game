//
//  ViewModelForMapAndShips.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 21.09.23.
//

import Foundation
import MultipeerConnectivity

enum ButtonType {
    case start
    case join
}

extension ViewModelForMapAndShips: InviteBannerViewTarget {
    @objc func inviteBannerTarhetForGet(_ sender: UIButton) {
        self.multipeerConectivityHandler.setConnectionBarier(with: true)
        self.leaveInovationToMultipeerConnectivity()
        functionalityWhenInviteBannerResponse()
    }
    
    @objc func inviteBannerTarhetForCancel(_ sender: UIButton) {
        self.multipeerConectivityHandler.setConnectionBarier(with: false)
        self.leaveInovationToMultipeerConnectivity()
        functionalityWhenInviteBannerResponse()
    }
}

extension ViewModelForMapAndShips: NetworkConnectionCheckerManagerDelegate {
    func provideStatus(_sender: NetworkConnectionCheckerManager, status: ConnectionStatus) {
        self.givenConnectionStatus = status
        if self.buttontype == .start {
            self.functionalityForStartButton()
        } else {
            self.functionalityForJoinButton()
        }
    }
}

final class ViewModelForMapAndShips {
    
    private var multipeerConectivityHandler: MultiplayerConectionAsMPCHandler! = nil
    private var shipsDataModel: DataModelForShipsSection = DataModelForShipsSection()
    private var mapDataModel: MapDataModel = MapDataModel()
    private var networkConnectionMonitor = NetworkConnectionCheckerManager()
    private(set) var setOfIndexPathsForHighlighting: Set<IndexPath> = Set<IndexPath>()
    private(set) var givenConnectionStatus: ConnectionStatus = .notConnected
    private var shipIndexPath:IndexPath! = nil
    private var buttontype: ButtonType! = nil
    private var addedShipsCount: Int = 0 {
        didSet {
            if addedShipsCount == 10 {
                givenDataForMapCopy = givenDataForMap
                functionalityWhenShipsCountAdded()
            }
        }
    }
    
    private(set) var givenDataOfShips: [String] = [String]() {
        didSet{
            self.functionalityWhenShipsSectionDataProvided()
        }
    }
    
    private(set) var givenDataForMap: [String] = [String]() {
        didSet {
            functionalityWhenMapSectionDataProvided()
        }
    }
    
    private var givenDataForMapCopy: [String] = [String]()
    
    var functionalityWhenShipsSectionDataProvided: () -> Void = {}
    var functionalityWhenShipsCountAdded: () -> Void = {}
    var functionalityWhenMapSectionDataProvided: () -> Void = {}
    var functionalityWhenInviteBannerResponse: () -> Void = {}
    var functionalityForStartButton: () -> Void = {}
    var functionalityForJoinButton: () -> Void = {}
    
    func getShipsDataModel() {
        self.givenDataOfShips = self.shipsDataModel.provideDataForShipsSectionRotatedLeft()
    }
    
    func setDelegateToNetworkManager() {
        self.networkConnectionMonitor = NetworkConnectionCheckerManager()
        self.networkConnectionMonitor.delegate = self
        self.networkConnectionMonitor.provideConnectionStatus()
    }
    
    func getShipsDataModelRotated() {
        self.givenDataOfShips = self.shipsDataModel.provideDataForForShipSectionRotatedRight()
    }
    
    func getMapDataModel() {
        self.givenDataForMap =  self.mapDataModel.provideData()
        self.givenDataForMapCopy = self.givenDataForMap
    }
    
    func setMultipeerConectivityHandler(with displayName: String) {
        self.multipeerConectivityHandler = MultiplayerConectionAsMPCHandler(displayName: displayName)
        self.multipeerConectivityHandler.setUpDelegates()
    }
    
    func provideConnectivityHandler() -> MultiplayerConectionAsMPCHandler {
        return self.multipeerConectivityHandler
    }
    
    func startMCAdvertiserAdvertising() {
        self.multipeerConectivityHandler.startAdvertising()
    }
    
    func stopMCAdvertiserAdvertising() {
        self.multipeerConectivityHandler.stopAdvertising()
    }
    
    func startBrowsingOfMCBrowser() {
        self.multipeerConectivityHandler.startBrowsing()
    }
    
    func stopBrowsingOfMCBrowser() {
        self.multipeerConectivityHandler.stopBrowsing()
    }
    
    func resetBrowser() {
        self.multipeerConectivityHandler.browserForConnect.delegate = nil
        self.multipeerConectivityHandler.resetBrowser()
    }
    
    func provideIndexPathsForHighlighting(indexPath: IndexPath,shipIndentificator:ShipsIdentifier) {
        self.setOfIndexPathsForHighlighting = self.mapDataModel.provideIndexPathsForHighlighting(indexPath: indexPath, shipIndentificator: shipIndentificator)
    }
    
    func resetSetOfindexPaths() {
        self.setOfIndexPathsForHighlighting = Set<IndexPath>()
    }
    
    func getData(on index: Int) -> String {
        return self.givenDataForMap[index]
    }
    
    func makeSettingInMapWithShip(minIndexPath: IndexPath, maxIndexPath: IndexPath, shipIndentifier: ShipsIdentifier, in addingFromShipsSection: Bool) {
        switch shipIndentifier {
        case .oneCellShip:
            if abs(minIndexPath.item - maxIndexPath.item) == 0 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "OneCellShipsSegment")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .oneCellShip) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {// as how i will try to bring two ships to each other, they areas will be intersects with each other
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .oneCellShip)) {
                        self.changeData(in: minIndexPath.item, with: "OneCellShipsSegment")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .oneCellShip) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                            
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .twoCellShip:
            if abs(minIndexPath.item - maxIndexPath.item) == 1 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "TwoCellsShipsSegmentOne")
                    self.mapDataModel.changeData(in: maxIndexPath.item, with: "TwoCellsShipsSegmentTwo")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .twoCellShip) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .twoCellShip)) {
                        self.changeData(in: minIndexPath.item, with: "TwoCellsShipsSegmentOne")
                        self.changeData(in: maxIndexPath.item, with: "TwoCellsShipsSegmentTwo")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .twoCellShip) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .threeCellShip:
            if abs(minIndexPath.item - maxIndexPath.item) == 2 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "ThreeCellsShipsSegmentOne")
                    self.mapDataModel.changeData(in: minIndexPath.item + 1, with: "ThreeCellsShipsSegmentTwo")
                    self.mapDataModel.changeData(in: maxIndexPath.item, with: "ThreeCellsShipsSegmentThree")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .threeCellShip) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .threeCellShip)) {
                        self.changeData(in: minIndexPath.item, with: "ThreeCellsShipsSegmentOne")
                        self.changeData(in: minIndexPath.item + 1, with: "ThreeCellsShipsSegmentTwo")
                        self.changeData(in: maxIndexPath.item, with: "ThreeCellsShipsSegmentThree")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .threeCellShip) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .fourCellShip:
            if abs(minIndexPath.item - maxIndexPath.item) == 3 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "FourCellShipsSegmentOne")
                    self.mapDataModel.changeData(in: minIndexPath.item + 1, with: "FourCellShipsSegmentTwo")
                    self.mapDataModel.changeData(in: minIndexPath.item + 2, with: "FourCellShipsSegmentThree")
                    self.mapDataModel.changeData(in: maxIndexPath.item, with: "FourCellShipsSegmentFour")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .fourCellShip) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .fourCellShip)) {
                        self.changeData(in: minIndexPath.item, with: "FourCellShipsSegmentOne")
                        self.changeData(in: minIndexPath.item + 1, with: "FourCellShipsSegmentTwo")
                        self.changeData(in: minIndexPath.item + 2, with: "FourCellShipsSegmentThree")
                        self.changeData(in: maxIndexPath.item, with: "FourCellShipsSegmentFour")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .fourCellShip) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .oneCellShipRotated:
            if abs(minIndexPath.item - maxIndexPath.item) == 0 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "OneCellShipsRotatedSegment")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .oneCellShipRotated) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .oneCellShipRotated)) {
                        self.changeData(in: minIndexPath.item, with: "OneCellShipsRotatedSegment")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .oneCellShipRotated) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .twoCellShipRotated:
            if abs(minIndexPath.item - maxIndexPath.item) == 11 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "TwoCellsShipsRotatedSegmentOne")
                    self.mapDataModel.changeData(in: maxIndexPath.item, with: "TwoCellsShipsRotatedSegmentTwo")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .twoCellShipRotated) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .twoCellShipRotated)) {
                        self.changeData(in: minIndexPath.item, with: "TwoCellsShipsRotatedSegmentOne")
                        self.changeData(in: maxIndexPath.item, with: "TwoCellsShipsRotatedSegmentTwo")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .twoCellShipRotated) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                    self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .threeCellShipRotated:
            if abs(minIndexPath.item - maxIndexPath.item) == 22 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "ThreeCellsShipsRotatedSegmentOne")
                    self.mapDataModel.changeData(in: minIndexPath.item + 11, with: "ThreeCellsShipsRotatedSegmentTwo")
                    self.mapDataModel.changeData(in: maxIndexPath.item, with: "ThreeCellsShipsRotatedSegmentThree")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .threeCellShipRotated) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in: self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .threeCellShipRotated)) {
                        self.changeData(in: minIndexPath.item, with: "ThreeCellsShipsRotatedSegmentOne")
                        self.changeData(in: minIndexPath.item + 11, with: "ThreeCellsShipsRotatedSegmentTwo")
                        self.changeData(in: maxIndexPath.item, with: "ThreeCellsShipsRotatedSegmentThree")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .threeCellShipRotated) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            }  else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        case .fourCellShipRotated:
            if abs(minIndexPath.item - maxIndexPath.item) == 33 {
                if addingFromShipsSection == true {
                    self.mapDataModel.changeData(in: minIndexPath.item, with: "FourCellShipsRotatedSegmentOne")
                    self.mapDataModel.changeData(in: minIndexPath.item + 11, with: "FourCellShipsRotatedSegmentTwo")
                    self.mapDataModel.changeData(in: minIndexPath.item + 22, with: "FourCellShipsRotatedSegmentThree")
                    self.mapDataModel.changeData(in: maxIndexPath.item, with: "FourCellShipsRotatedSegmentFour")
                    for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .fourCellShipRotated) {
                        self.mapDataModel.changeData(in: i.item, with: "mapCellMarked")
                    }
                } else {
                    if self.isContainSegment(in:self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .fourCellShipRotated)) {
                        self.changeData(in: minIndexPath.item, with: "FourCellShipsRotatedSegmentOne")
                        self.changeData(in: minIndexPath.item + 11, with: "FourCellShipsRotatedSegmentTwo")
                        self.changeData(in: minIndexPath.item + 22, with: "FourCellShipsRotatedSegmentThree")
                        self.changeData(in: maxIndexPath.item, with: "FourCellShipsRotatedSegmentFour")
                        for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: minIndexPath, shipIndentificator: .fourCellShipRotated) {
                            self.changeData(in: i.item, with: "mapCellMarked")
                        }
                        self.mapDataModel.setDataModelWithIncomingChange(with: self.givenDataForMap)
                    }
                }
                self.getMapDataModel()
                self.givenDataForMapCopy = self.givenDataForMap
                if addingFromShipsSection == true {
                    self.addedShipsCount += 1
                    self.changeShipsData()
                }
            } else {
                self.restoreData()
                self.shipIndexPath = nil
                return
            }
        }
    }
    
    func prepareToRemoveShip(on idexPath: IndexPath) {
        self.shipIndexPath = idexPath
    }
    
    func changeShipsData() {
        self.shipsDataModel.changeData(on: self.shipIndexPath.item)
        self.shipIndexPath = nil
        self.getShipsDataModel()
    }
    
    @objc func getRandomAddedMap() {
        self.givenDataForMap = self.mapDataModel.provideDataFromRandom()
        self.givenDataOfShips = self.shipsDataModel.resetShipsDataModel()
        self.addedShipsCount = 10
    }
    
    func changeDataBy(index: Int) {
        switch self.givenDataForMap[index] {
        case "OneCellShipsSegment":
            self.givenDataForMap[index] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .oneCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "OneCellShipsRotatedSegment":
            self.givenDataForMap[index] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .oneCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "TwoCellsShipsSegmentOne":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index + 1] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .twoCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "TwoCellsShipsSegmentTwo":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 1] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 1, section: 1), shipIndentificator: .twoCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "TwoCellsShipsRotatedSegmentOne":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index + 11] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .twoCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "TwoCellsShipsRotatedSegmentTwo":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 11] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 11, section: 1), shipIndentificator: .twoCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "ThreeCellsShipsSegmentOne":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index + 1] = "mappCelll"
            self.givenDataForMap[index + 2] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .threeCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "ThreeCellsShipsSegmentTwo":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 1] = "mappCelll"
            self.givenDataForMap[index + 1] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 1, section: 1), shipIndentificator: .threeCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "ThreeCellsShipsSegmentThree":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 1] = "mappCelll"
            self.givenDataForMap[index - 2] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 2, section: 1), shipIndentificator: .threeCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "ThreeCellsShipsRotatedSegmentOne":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index + 11] = "mappCelll"
            self.givenDataForMap[index + 22] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .threeCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "ThreeCellsShipsRotatedSegmentTwo":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 11] = "mappCelll"
            self.givenDataForMap[index + 11] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 11, section: 1), shipIndentificator: .threeCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "ThreeCellsShipsRotatedSegmentThree":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 11] = "mappCelll"
            self.givenDataForMap[index - 22] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 22, section: 1), shipIndentificator: .threeCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsSegmentOne":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index + 1] = "mappCelll"
            self.givenDataForMap[index + 2] = "mappCelll"
            self.givenDataForMap[index + 3] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .fourCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsSegmentTwo":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 1] = "mappCelll"
            self.givenDataForMap[index + 1] = "mappCelll"
            self.givenDataForMap[index + 2] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 1, section: 1), shipIndentificator: .fourCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsSegmentThree":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 1] = "mappCelll"
            self.givenDataForMap[index + 1] = "mappCelll"
            self.givenDataForMap[index - 2] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 2, section: 1), shipIndentificator: .fourCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsSegmentFour":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 1] = "mappCelll"
            self.givenDataForMap[index - 2] = "mappCelll"
            self.givenDataForMap[index - 3] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 3, section: 1), shipIndentificator: .fourCellShip) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsRotatedSegmentOne":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index + 11] = "mappCelll"
            self.givenDataForMap[index + 22] = "mappCelll"
            self.givenDataForMap[index + 33] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index, section: 1), shipIndentificator: .fourCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsRotatedSegmentTwo":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 11] = "mappCelll"
            self.givenDataForMap[index + 11] = "mappCelll"
            self.givenDataForMap[index + 22] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index-11, section: 1), shipIndentificator: .fourCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsRotatedSegmentThree":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 11] = "mappCelll"
            self.givenDataForMap[index - 22] = "mappCelll"
            self.givenDataForMap[index + 11] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 22, section: 1), shipIndentificator: .fourCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        case "FourCellShipsRotatedSegmentFour":
            self.givenDataForMap[index] = "mappCelll"
            self.givenDataForMap[index - 11] = "mappCelll"
            self.givenDataForMap[index - 22] = "mappCelll"
            self.givenDataForMap[index - 33] = "mappCelll"
            for i in self.mapDataModel.provideIndexPathsForHighlighting(indexPath: IndexPath(item: index - 33, section: 1), shipIndentificator: .fourCellShipRotated) {
                if !([0,1,2,3,4,5,6,7,8,9,10,11,22,33,44,55,66,77,88,99,110].contains(i.item)) && i.item <= 120 {
                    if self.mapDataModel.provideWaterMarkCount(for: i.item) == 1 {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                        self.givenDataForMap[i.item] = "mappCelll"
                    } else {
                        self.mapDataModel.decreaseWaterMarkCount(for: i.item)
                    }
                }
            }
        default:
            break
        }
    }
    
    func restoreData() {
        self.givenDataForMap = self.givenDataForMapCopy
    }
    
    func changeData(in index: Int, with data: String) {
        if index <= 120 {
            if !["","A","B","C","D","E","F","G","H","I","J","1","2","3","4","5","6","7","8","9","10"].contains(self.givenDataForMap[index]) {
                if data == "mapCellMarked" {
                    self.mapDataModel.increaseWaterMarkCount(for: index)
                }
                self.givenDataForMap[index] = data
            }
        }
    }
    
    func isContainSegment(in range: Set<IndexPath>) -> Bool {
        for i in range {
            if i.item <= 120 {
                if MapCellContainedSegment(rawValue: self.givenDataForMap[i.item]) != nil && MapCellContainedSegment(rawValue: self.givenDataForMap[i.item]) != .waterMark {
                    return false
                }
            }
        }
        return true
    }
    
    func performRotation(on indexPath: IndexPath, with indentifier: ShipsIdentifier) {
        
        var minIndexPath: IndexPath? = nil
        var maxIndexPath: IndexPath? = nil
        
        switch self.givenDataForMap[indexPath.item] {
        case "OneCellShipsSegment":
            minIndexPath = indexPath
            maxIndexPath = indexPath
        case "OneCellShipsRotatedSegment":
            minIndexPath = indexPath
            maxIndexPath = indexPath
        case "TwoCellsShipsSegmentOne":
            if indexPath.item + 11 <= 120 {
                minIndexPath = indexPath
                maxIndexPath = IndexPath(item: indexPath.item + 11, section: indexPath.section)
            }
        case "TwoCellsShipsSegmentTwo":
            if indexPath.item + 10 <= 120 {
                minIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item + 10, section: indexPath.section)
            }
        case "TwoCellsShipsRotatedSegmentOne":
            if indexPath.item + 1 <= 120 {
                minIndexPath = indexPath
                maxIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            }
        case "TwoCellsShipsRotatedSegmentTwo": // indexPath.item we getted <= 120
            minIndexPath = IndexPath(item: indexPath.item - 11, section: indexPath.section)
            maxIndexPath = IndexPath(item: indexPath.item - 10, section: indexPath.section)
        case "ThreeCellsShipsSegmentOne":
            if indexPath.item + 22 <= 120 {
                minIndexPath = indexPath
                maxIndexPath = IndexPath(item: indexPath.item + 22, section: indexPath.section)
            }
        case "ThreeCellsShipsSegmentTwo":
            if indexPath.item + 21 <= 120 {
                minIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item + 21, section: indexPath.section)
            }
        case "ThreeCellsShipsSegmentThree":
            if indexPath.item + 20 <= 120 {
                minIndexPath = IndexPath(item: indexPath.item - 2, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item + 20, section: indexPath.section)
            }
        case "ThreeCellsShipsRotatedSegmentOne":
            if indexPath.item + 2 <= 120 {
                minIndexPath = indexPath
                maxIndexPath = IndexPath(item: indexPath.item + 2, section: indexPath.section)
            }
        case "ThreeCellsShipsRotatedSegmentTwo":
                minIndexPath = IndexPath(item: indexPath.item - 11, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item - 9, section: indexPath.section)
        case "ThreeCellsShipsRotatedSegmentThree":
            minIndexPath = IndexPath(item: indexPath.item - 22, section: indexPath.section)
            maxIndexPath = IndexPath(item: indexPath.item - 20, section: indexPath.section)
        case "FourCellShipsSegmentOne":
            if indexPath.item + 33 <= 120 {
                minIndexPath = indexPath
                maxIndexPath = IndexPath(item: indexPath.item + 33, section: indexPath.section)
            }
        case "FourCellShipsSegmentTwo":
            if indexPath.item + 32 <= 120 {
                minIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item + 32, section: indexPath.section)
            }
        case "FourCellShipsSegmentThree":
            if indexPath.item + 31 <= 120 {
                minIndexPath = IndexPath(item: indexPath.item - 2, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item + 31, section: indexPath.section)
            }
        case "FourCellShipsSegmentFour":
            if indexPath.item + 30 <= 120 {
                minIndexPath = IndexPath(item: indexPath.item - 3, section: indexPath.section)
                maxIndexPath = IndexPath(item: indexPath.item + 30, section: indexPath.section)
            }
        case "FourCellShipsRotatedSegmentOne":
            if indexPath.item + 3 <= 120 {
                minIndexPath = indexPath
                maxIndexPath = IndexPath(item: indexPath.item + 3, section: indexPath.section)
            }
        case "FourCellShipsRotatedSegmentTwo":
            minIndexPath = IndexPath(item: indexPath.item - 11, section: indexPath.section)
            maxIndexPath = IndexPath(item: indexPath.item - 8, section: indexPath.section)
        case "FourCellShipsRotatedSegmentThree":
            minIndexPath = IndexPath(item: indexPath.item - 22, section: indexPath.section)
            maxIndexPath = IndexPath(item: indexPath.item - 19, section: indexPath.section)
        case "FourCellShipsRotatedSegmentFour":
            minIndexPath = IndexPath(item: indexPath.item - 33, section: indexPath.section)
            maxIndexPath = IndexPath(item: indexPath.item - 30, section: indexPath.section)

        default:
            return
        }
        
        guard let minIndexPath, let maxIndexPath else {return}
        self.changeDataBy(index: indexPath.item)
        switch indentifier {
        case .oneCellShip:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .oneCellShipRotated, in: false)
        case .twoCellShip:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .twoCellShipRotated, in: false)
        case .threeCellShip:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .threeCellShipRotated, in: false)
        case .fourCellShip:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .fourCellShipRotated, in: false)
        case .oneCellShipRotated:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .oneCellShip, in: false)
        case .twoCellShipRotated:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .twoCellShip, in: false)
        case .threeCellShipRotated:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .threeCellShip, in: false)
        case .fourCellShipRotated:
            self.makeSettingInMapWithShip(minIndexPath: minIndexPath, maxIndexPath: maxIndexPath, shipIndentifier: .fourCellShip, in: false)
        }
    }
    
    func isFullMapSetted() -> Bool {
        return (self.addedShipsCount == 10)
    }
    
    func provideDataForSelfMapOnBattle() -> [String] {
        return self.givenDataForMapCopy.map({$0 == "mapCellMarked" ? "mappCelll": String($0)})
    }
    
    func provide() -> [Int:Int] {
        self.mapDataModel.provide()
    }
    
    func setFunctionalityWhenConnectionEstablished(with functionality: @escaping ()->Void) {
        self.multipeerConectivityHandler.functionalityWhenConnectionEstablished = functionality
    }
    
    func setFunctionalityWhenConnectionProvided(with functionality: @escaping ()->Void) {
        self.multipeerConectivityHandler.functionlaityWhenConnectionInviteProvided = functionality
    }
    
    func enterInovationToMultipeerConnectivity() {
        self.multipeerConectivityHandler.group.enter()
    }
    
    func leaveInovationToMultipeerConnectivity() {
        self.multipeerConectivityHandler.group.leave()
    }
    
    func setButtonType(with type: ButtonType) {
        self.buttontype = type
    }
}
