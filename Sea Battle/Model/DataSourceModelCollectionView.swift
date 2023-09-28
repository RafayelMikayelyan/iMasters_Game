//
//  DataSourceModelCollectionView.swift
//  Sea Battle
//
//  Created by Ashot Hovhannisyan on 19.09.23.
//

import Foundation




enum HighlightColor {
    case red
    case green
    case fixed
}

enum MapCellContainedSegment: String {
    case waterMark = "mapCellMarked"
    case oneCellShipSegment = "OneCellShipsSegment"
    case oneCellShipRotatedSegment = "OneCellShipsRotatedSegment"
    case twoCellShipFirstSegment = "TwoCellsShipsSegmentOne"
    case twoCellShipSecondSegment = "TwoCellsShipsSegmentTwo"
    case twoCellShipRotatedFirstSegment = "TwoCellsShipsRotatedSegmentOne"
    case twoCellShipRotatedSecondSegment = "TwoCellsShipsRotatedSegmentTwo"
    case threeCellShipFirstSegment = "ThreeCellsShipsSegmentOne"
    case threeCellShipSecondSegment = "ThreeCellsShipsSegmentTwo"
    case threeCellShipThirdSegment = "ThreeCellsShipsSegmentThree"
    case threeCellShipRotatedFirstSegment = "ThreeCellsShipsRotatedSegmentOne"
    case threeCellShipRotatedSecondSegment = "ThreeCellsShipsRotatedSegmentTwo"
    case threeCellShipRotatedThirdSegment = "ThreeCellsShipsRotatedSegmentThree"
    case fourCellShipFirstSegment = "FourCellShipsSegmentOne"
    case fourCellShipSecondSegment = "FourCellShipsSegmentTwo"
    case fourCellShipThirdSegment = "FourCellShipsSegmentThree"
    case fourCellShipFourthSegment = "FourCellShipsSegmentFour"
    case fourCellShipRotatedFirstSegment = "FourCellShipsRotatedSegmentOne"
    case fourCellShipRotatedSecondSegment = "FourCellShipsRotatedSegmentTwo"
    case fourCellShipRotatedThirdSegment = "FourCellShipsRotatedSegmentThree"
    case fourCellShipRotatedFourthSegment = "FourCellShipsRotatedSegmentFour"
}

enum ShipsIdentifier: String {
    case oneCellShip = "OneCellShips"
    case twoCellShip = "TwoCellsShips"
    case threeCellShip = "ThreeCellsShips"
    case fourCellShip = "FourCellShips"
    case oneCellShipRotated = "OneCellShipsRotated"
    case twoCellShipRotated = "TwoCellsShipsRotated"
    case threeCellShipRotated = "ThreeCellsShipsRotated"
    case fourCellShipRotated = "FourCellShipsRotated"
}

enum RowColIdentifier: String {
    case initial = ""
    case seaCell = "mappCelll"
    case rowA = "A"
    case rowB = "B"
    case rowC = "C"
    case rowD = "D"
    case rowE = "E"
    case rowF = "F"
    case rowG = "G"
    case rowH = "H"
    case rowI = "I"
    case row = "J"
    case colOne = "1"
    case colTwo = "2"
    case colThree = "3"
    case colFour = "4"
    case colFive = "5"
    case colSix = "6"
    case colSeven = "7"
    case colEight = "8"
    case colNine = "9"
    case colTen = "10"
}

struct DataModelForShipsSection {
    private var shipsSectionDataModel: [String] =  ["OneCellShips","OneCellShips","OneCellShips","OneCellShips","TwoCellsShips","TwoCellsShips","TwoCellsShips","ThreeCellsShips","ThreeCellsShips","FourCellShips"]
    
    private var shipsSectionDataModelRotated:[String] = ["OneCellShipsRotated","OneCellShipsRotated","OneCellShipsRotated","OneCellShipsRotated","TwoCellsShipsRotated","TwoCellsShipsRotated","TwoCellsShipsRotated","ThreeCellsShipsRotated","ThreeCellsShipsRotated","FourCellShipsRotated"]
    
    func provideDataForShipsSectionRotatedLeft() -> [String] {
        return self.shipsSectionDataModel
    }
    
    func provideDataForForShipSectionRotatedRight() -> [String] {
        return self.shipsSectionDataModelRotated
    }
    
    mutating func changeData(on index: Int) {
        self.shipsSectionDataModel[index] = ""
        self.shipsSectionDataModelRotated[index] = ""
    }
    
    func resetShipsDataModel() -> [String] {
        return ["","","","","","","","","",""]
    }
}

struct MapDataModel {
    private var dataModelForMap: [String] = {
        let dict:[Int:String] = [
            11:"A",
            22:"B",
            33:"C",
            44:"D",
            55:"E",
            66:"F",
            77:"G",
            88:"H",
            99:"I",
            110:"J"
        ]
        var data:[String] = [""]
        for i in 1...10 {
            data.append("\(i)")
        }
        for i in 11...120 {
            if dict[i] != nil {
                data.append(dict[i]!)
            } else {
                data.append("mappCelll")
            }
        }
        return data
    }()
    
    private var randomAddedShipsInMapDataMode:[([String],[Int:Int])] = [(["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "mappCelll", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "B", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "mappCelll", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mappCelll", "C", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mappCelll", "mappCelll", "mappCelll", "mappCelll", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mapCellMarked", "D", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mappCelll", "mappCelll", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentOne", "E", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentTwo", "F", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsRotatedSegmentOne", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "FourCellShipsRotatedSegmentThree", "G", "mapCellMarked", "TwoCellsShipsSegmentOne", "TwoCellsShipsSegmentTwo", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsRotatedSegmentTwo", "mapCellMarked", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentFour", "H", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsRotatedSegmentThree", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "I", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "mappCelll", "J", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsSegmentOne", "ThreeCellsShipsSegmentTwo", "ThreeCellsShipsSegmentThree", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll"],[79: 0, 91: 2, 47: 0, 50: 0, 73: 2, 76: 0, 5: 0, 2: 0, 36: 0, 65: 0, 78: 1, 46: 1, 97: 2, 24: 2, 99: 0, 17: 0, 81: 1, 59: 0, 41: 0, 112: 1, 101: 0, 62: 2, 93: 1, 86: 2, 4: 0, 42: 2, 113: 2, 31: 1, 75: 2, 8: 0, 20: 1, 52: 1, 40: 1, 85: 1, 118: 1, 22: 0, 108: 1, 53: 2, 116: 0, 32: 0, 66: 0, 7: 0, 49: 0, 21: 0, 16: 0, 83: 0, 77: 0, 3: 0, 27: 0, 109: 0, 18: 1, 54: 0, 114: 0, 88: 0, 67: 1, 43: 1, 84: 2, 55: 0, 102: 2, 107: 0, 35: 1, 69: 1, 106: 3, 104: 2, 44: 0, 33: 0, 10: 0, 23: 2, 115: 0, 25: 1, 120: 0, 26: 0, 105: 2, 92: 1, 1: 0, 89: 2, 13: 0, 9: 0, 30: 0, 28: 0, 61: 1, 48: 0, 34: 0, 57: 1, 70: 1, 19: 1, 110: 0, 98: 1, 6: 0, 38: 0, 15: 0, 95: 2, 82: 1, 29: 1, 71: 1, 103: 1, 74: 0, 100: 1, 51: 1, 64: 2, 39: 0, 45: 0, 0: 0, 87: 0, 63: 1, 11: 0, 94: 0, 80: 0, 60: 1, 117: 2, 58: 0, 111: 1, 72: 0, 12: 1, 96: 1, 119: 1, 90: 2, 68: 1, 14: 1, 56: 1, 37: 0]),(["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "FourCellShipsSegmentOne", "FourCellShipsSegmentTwo", "FourCellShipsSegmentThree", "FourCellShipsSegmentFour", "mapCellMarked", "B", "mappCelll", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "C", "mappCelll", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mappCelll", "D", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mappCelll", "E", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "F", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "G", "ThreeCellsShipsSegmentOne", "ThreeCellsShipsSegmentTwo", "ThreeCellsShipsSegmentThree", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsSegmentOne", "ThreeCellsShipsSegmentTwo", "ThreeCellsShipsSegmentThree", "H", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "I", "mappCelll", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "mappCelll", "J", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll"],[36: 0, 113: 1, 19: 0, 40: 1, 84: 2, 105: 1, 104: 1, 72: 1, 33: 0, 68: 2, 47: 2, 103: 1, 24: 1, 29: 2, 9: 0, 98: 1, 66: 0, 56: 1, 44: 0, 37: 2, 85: 0, 6: 0, 30: 2, 62: 1, 119: 1, 114: 1, 117: 1, 76: 1, 28: 1, 42: 1, 77: 0, 27: 1, 58: 1, 106: 2, 86: 0, 46: 2, 83: 1, 32: 1, 109: 0, 65: 0, 41: 0, 26: 1, 78: 0, 31: 2, 5: 0, 3: 0, 25: 0, 71: 1, 67: 2, 93: 1, 16: 1, 4: 0, 23: 0, 17: 0, 101: 1, 45: 1, 64: 1, 97: 2, 90: 2, 54: 0, 21: 1, 1: 0, 94: 0, 12: 0, 75: 1, 69: 2, 15: 1, 81: 1, 73: 1, 2: 0, 35: 1, 70: 2, 89: 1, 112: 1, 53: 1, 100: 0, 80: 0, 34: 0, 99: 0, 57: 0, 111: 0, 108: 1, 79: 0, 91: 2, 22: 0, 52: 0, 92: 2, 55: 0, 95: 3, 61: 1, 7: 0, 43: 0, 39: 1, 116: 0, 0: 0, 48: 2, 63: 1, 8: 0, 60: 0, 115: 0, 110: 0, 49: 0, 13: 1, 38: 1, 14: 1, 88: 0, 59: 1, 118: 1, 50: 1, 102: 0, 107: 0, 74: 1, 11: 0, 96: 2, 82: 1, 18: 0, 87: 0, 120: 0, 10: 0, 20: 0, 51: 1]),(["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mapCellMarked", "ThreeCellsShipsSegmentOne", "ThreeCellsShipsSegmentTwo", "ThreeCellsShipsSegmentThree", "mapCellMarked", "B", "mappCelll", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "C", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "TwoCellsShipsSegmentOne", "TwoCellsShipsSegmentTwo", "mapCellMarked", "mappCelll", "mappCelll", "D", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "E", "mapCellMarked", "TwoCellsShipsSegmentOne", "TwoCellsShipsSegmentTwo", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "F", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "FourCellShipsRotatedSegmentOne", "mapCellMarked", "G", "mappCelll", "mapCellMarked", "OneCellShipsSegment", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentTwo", "mapCellMarked", "H", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentThree", "mapCellMarked", "I", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "TwoCellsShipsSegmentOne", "TwoCellsShipsSegmentTwo", "mapCellMarked", "FourCellShipsRotatedSegmentFour", "mapCellMarked", "J", "ThreeCellsShipsSegmentOne", "ThreeCellsShipsSegmentTwo", "ThreeCellsShipsSegmentThree", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked"],[14: 1, 108: 0, 6: 0, 4: 0, 45: 1, 118: 2, 40: 0, 81: 2, 5: 0, 28: 2, 78: 0, 11: 0, 83: 2, 68: 2, 66: 0, 110: 0, 10: 0, 39: 0, 56: 1, 88: 0, 8: 0, 37: 1, 111: 0, 3: 0, 17: 1, 71: 0, 73: 0, 25: 0, 97: 0, 49: 1, 35: 1, 98: 1, 103: 1, 44: 0, 54: 0, 75: 0, 67: 1, 61: 2, 113: 0, 24: 1, 51: 1, 29: 2, 16: 0, 53: 0, 43: 0, 9: 0, 36: 1, 79: 1, 0: 0, 119: 1, 33: 0, 95: 1, 27: 1, 101: 1, 64: 1, 112: 0, 19: 0, 13: 1, 106: 0, 80: 0, 31: 1, 72: 2, 55: 0, 84: 1, 100: 1, 104: 1, 114: 1, 63: 2, 77: 0, 20: 0, 18: 0, 47: 1, 120: 1, 48: 1, 107: 2, 117: 1, 30: 2, 70: 3, 82: 1, 69: 2, 87: 1, 21: 1, 109: 1, 89: 0, 41: 1, 52: 1, 22: 0, 7: 0, 60: 1, 102: 1, 46: 1, 32: 1, 96: 2, 86: 0, 57: 0, 38: 1, 59: 2, 15: 1, 23: 0, 105: 0, 34: 0, 58: 0, 76: 1, 99: 0, 93: 1, 90: 1, 65: 1, 85: 2, 92: 1, 74: 2, 26: 1, 2: 0, 62: 1, 42: 0, 12: 0, 116: 1, 91: 1, 94: 1, 50: 1, 1: 0, 115: 1]),(["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "B", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsRotatedSegmentOne", "C", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "ThreeCellsShipsRotatedSegmentTwo", "D", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsRotatedSegmentThree", "E", "mappCelll", "mapCellMarked", "OneCellShipsRotatedSegment", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "F", "mappCelll", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mappCelll", "G", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentOne", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mapCellMarked", "H", "OneCellShipsRotatedSegment", "mapCellMarked", "FourCellShipsRotatedSegmentTwo", "mapCellMarked", "TwoCellsShipsRotatedSegmentOne", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mapCellMarked", "ThreeCellsShipsRotatedSegmentOne", "I", "mapCellMarked", "mapCellMarked", "FourCellShipsRotatedSegmentThree", "mapCellMarked", "TwoCellsShipsRotatedSegmentTwo", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "ThreeCellsShipsRotatedSegmentTwo", "J", "mappCelll", "mapCellMarked", "FourCellShipsRotatedSegmentFour", "mapCellMarked", "mapCellMarked", "mapCellMarked", "mappCelll", "mappCelll", "mapCellMarked", "ThreeCellsShipsRotatedSegmentThree"],[46: 1, 15: 1, 113: 0, 17: 1, 112: 1, 94: 1, 66: 0, 111: 0, 62: 1, 22: 0, 115: 1, 92: 2, 91: 0, 33: 0, 52: 1, 47: 1, 86: 2, 103: 2, 54: 0, 37: 1, 76: 0, 67: 0, 83: 1, 60: 0, 59: 1, 10: 0, 2: 0, 81: 2, 110: 0, 48: 1, 29: 1, 39: 1, 105: 1, 21: 1, 68: 2, 34: 1, 116: 1, 89: 0, 106: 0, 120: 0, 71: 0, 65: 1, 119: 1, 72: 0, 75: 1, 79: 2, 90: 2, 69: 2, 1: 0, 93: 0, 78: 1, 109: 0, 5: 0, 57: 1, 63: 1, 114: 2, 28: 1, 49: 0, 31: 2, 35: 1, 18: 0, 26: 1, 16: 0, 51: 1, 99: 0, 100: 1, 8: 0, 58: 0, 44: 0, 23: 1, 118: 0, 85: 0, 55: 0, 43: 0, 82: 1, 73: 1, 6: 0, 84: 1, 42: 2, 96: 1, 0: 0, 40: 1, 108: 1, 3: 0, 117: 0, 11: 0, 95: 1, 20: 1, 88: 0, 102: 0, 77: 0, 87: 1, 4: 0, 9: 0, 45: 0, 19: 0, 24: 0, 25: 1, 98: 0, 104: 0, 14: 1, 7: 0, 61: 0, 41: 0, 36: 1, 32: 0, 70: 2, 38: 1, 53: 2, 64: 2, 80: 0, 74: 0, 13: 1, 56: 0, 50: 0, 97: 2, 101: 2, 107: 0, 12: 1, 27: 0, 30: 1])]
    
    private var waterMarksCountByIndex: [Int:Int] = {
        var data: [Int:Int] = [Int:Int]()
        for i in 0...120 {
            data[i] = 0
        }
        return data
    }()
    
    mutating func increaseWaterMarkCount(for index: Int) {
        self.waterMarksCountByIndex[index]! =  self.waterMarksCountByIndex[index]! + 1
    }
    
    mutating func decreaseWaterMarkCount(for index: Int) {
        if self.waterMarksCountByIndex[index]! - 1 >= 0 {
            self.waterMarksCountByIndex[index]! =  self.waterMarksCountByIndex[index]! - 1
        }
    }
    
    func provideWaterMarkCount(for index: Int) -> Int {
        return self.waterMarksCountByIndex[index]!
    }
    
    func provide() -> [Int:Int] {
        return self.waterMarksCountByIndex
    }
    
    func provideData() -> [String] {
        return self.dataModelForMap
    }
    
    mutating func provideDataFromRandom() -> [String] {
        let returnedValue = self.randomAddedShipsInMapDataMode.randomElement()!
        self.dataModelForMap = returnedValue.0
        self.waterMarksCountByIndex = returnedValue.1
        return returnedValue.0
    }
    
    mutating func changeData(in index: Int, with data: String) {
        if index <= 120 {
            if !["","A","B","C","D","E","F","G","H","I","J","1","2","3","4","5","6","7","8","9","10"].contains(self.dataModelForMap[index]) {
                if data == "mapCellMarked" {
                    self.increaseWaterMarkCount(for: index)
                }
                self.dataModelForMap[index] = data
            }
        }
    }
    
    func provideIndexPathsForHighlighting(indexPath: IndexPath,shipIndentificator:ShipsIdentifier) -> Set<IndexPath> {
        switch shipIndentificator {
        case .oneCellShip:
            return [IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item+1, section: indexPath.section),
                    IndexPath(item: indexPath.item+11, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section)]
        case .twoCellShip:
            return [IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item+2, section: indexPath.section),
                    IndexPath(item: indexPath.item+11, section: indexPath.section),
                    IndexPath(item: indexPath.item-9, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section),
                    IndexPath(item: indexPath.item+13, section: indexPath.section)]
        case .threeCellShip:
            return [IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item+3, section: indexPath.section),
                    IndexPath(item: indexPath.item+11, section: indexPath.section),
                    IndexPath(item: indexPath.item-8, section: indexPath.section),
                    IndexPath(item: indexPath.item-9, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section),
                    IndexPath(item: indexPath.item+13, section: indexPath.section),
                    IndexPath(item: indexPath.item+14, section: indexPath.section)]
        case .fourCellShip:
            return [IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item+4, section: indexPath.section),
                    IndexPath(item: indexPath.item+11, section: indexPath.section),
                    IndexPath(item: indexPath.item-7, section: indexPath.section),
                    IndexPath(item: indexPath.item-8, section: indexPath.section),
                    IndexPath(item: indexPath.item-9, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section),
                    IndexPath(item: indexPath.item+13, section: indexPath.section),
                    IndexPath(item: indexPath.item+14, section: indexPath.section),
                    IndexPath(item: indexPath.item+15, section: indexPath.section),
            ]
        case .oneCellShipRotated:
            return [IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item+1, section: indexPath.section),
                    IndexPath(item: indexPath.item+11, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section)]
        case .twoCellShipRotated:
            return [IndexPath(item: indexPath.item+1, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section),
                    IndexPath(item: indexPath.item+21, section: indexPath.section),
                    IndexPath(item: indexPath.item+22, section: indexPath.section),
                    IndexPath(item: indexPath.item+23, section: indexPath.section),
                    IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section)]
        case .threeCellShipRotated:
            return [IndexPath(item: indexPath.item+1, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section),
                    IndexPath(item: indexPath.item+21, section: indexPath.section),
                    IndexPath(item: indexPath.item+23, section: indexPath.section),
                    IndexPath(item: indexPath.item+32, section: indexPath.section),
                    IndexPath(item: indexPath.item+33, section: indexPath.section),
                    IndexPath(item: indexPath.item+34, section: indexPath.section),
                    IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section)]
        case .fourCellShipRotated:
            return [IndexPath(item: indexPath.item+1, section: indexPath.section),
                    IndexPath(item: indexPath.item+10, section: indexPath.section),
                    IndexPath(item: indexPath.item+12, section: indexPath.section),
                    IndexPath(item: indexPath.item+21, section: indexPath.section),
                    IndexPath(item: indexPath.item+23, section: indexPath.section),
                    IndexPath(item: indexPath.item+32, section: indexPath.section),
                    IndexPath(item: indexPath.item+34, section: indexPath.section),
                    IndexPath(item: indexPath.item+43, section: indexPath.section),
                    IndexPath(item: indexPath.item+44, section: indexPath.section),
                    IndexPath(item: indexPath.item+45, section: indexPath.section),
                    IndexPath(item: indexPath.item-1, section: indexPath.section),
                    IndexPath(item: indexPath.item-10, section: indexPath.section),
                    IndexPath(item: indexPath.item-11, section: indexPath.section),
                    IndexPath(item: indexPath.item-12, section: indexPath.section)]
        }
    }
    
    mutating func setDataModelWithIncomingChange(with data: [String]) {
        self.dataModelForMap = data
    }
    
    func getData(on index: Int) -> String {
        return self.dataModelForMap[index]
    }
}


