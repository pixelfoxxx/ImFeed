//
//  ImagesListScreenModel.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 03/02/2024.
//

import UIKit

struct ImagesListScreenModel {
    struct TableData {
        enum Section {
            case simpleSection(cells: [Cell])
            
            var cells: [Cell] {
                switch self {
                case let .simpleSection(cells):
                    return cells
                }
            }
        }
        
        enum Cell {
            case imageCell(ImageCellViewModel)
        }
        
        let sections: [Section]
    }
    
    let tableData: TableData
    let backgroundColor: UIColor
    
    static let empty: ImagesListScreenModel = .init(tableData: .init(sections: []), backgroundColor: .clear)
}
