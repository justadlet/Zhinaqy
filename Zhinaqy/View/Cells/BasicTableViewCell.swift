//
//  RightDetailTableViewCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    enum TableViewState {
        case rightDetail(title: String, details: String?, accessory: UITableViewCell.AccessoryType)
        case subtitle(title: String, details: String?, accessory: UITableViewCell.AccessoryType)
        case title(title: String, accessory: UITableViewCell.AccessoryType)
    }
    
    private let cellType: TableViewState
    
    init(style: UITableViewCell.CellStyle, cellType: TableViewState) {
        self.cellType = cellType
        super.init(style: style, reuseIdentifier: nil)
        self.setValues()
    }
    
    
    
    func setValues() {
        switch cellType {
        case .rightDetail(let title, let details, let accessory):
            self.textLabel?.text = title
            self.detailTextLabel?.text = details
            self.detailTextLabel?.textColor = Color.label
            self.accessoryType = accessory
        case .subtitle(let title, let details, let accessory):
            self.textLabel?.text = title
            self.detailTextLabel?.text = details
            self.detailTextLabel?.textColor = Color.secondaryLabel
            self.accessoryType = accessory
        case .title(let title, let accessory):
            self.textLabel?.text = title
            self.detailTextLabel?.text = nil
            self.accessoryType = accessory
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
