//
//  DayCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import CoreData


class DayCell: UICollectionViewCell {
    
    static let reuseId = "dayCell"
    
    lazy private var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.anchorSize(to: CGSize(width: 32, height: 32))
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    
    lazy private var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.layer.cornerRadius = 3
        return bottomView
    }()
    
    
    
    func configure(date: Date,
                   section: NSFetchedResultsSectionInfo?,
                   currentDay: Bool = false,
                   currentMonth: Bool = true) {
        
        self.dayLabel.text = "\(date.element(.day))"
        
        self.dayLabel.backgroundColor = currentDay ? Color.main : UIColor.clear
        bottomView.backgroundColor = (section?.objects?.isEmpty ?? true) ? .clear : Color.opaqueSeparator
        
        if currentDay {
            self.dayLabel.font = .systemFont(ofSize: 17, weight: .bold)
        } else if date.same(.day, as: Date()) {
            self.dayLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        } else {
            self.dayLabel.font = .systemFont(ofSize: 17, weight: .regular)
        }
        if currentMonth {
            self.dayLabel.textColor = (!currentDay && date.same(.day, as: Date())) ? Color.main : Color.label
        } else {
            self.dayLabel.textColor = Color.secondaryLabel
        }
        
        addViews()
        setConstraints()
    }
    
    func addViews() {
        self.addSubview(dayLabel)
        self.addSubview(bottomView)
    }
    
    
    func setConstraints() {
        dayLabel.anchorCenter(x: centerXAnchor,
                              y: centerYAnchor)
        bottomView.anchorCenter(x: centerXAnchor)
        bottomView.anchor(top: dayLabel.bottomAnchor,
                          padding: .init(top: 3, left: 0, bottom: 0, right: 0),
                          size: .init(width: 6, height: 6))
    }
    
    
    override func prepareForReuse() {
        self.dayLabel.removeFromSuperview()
    }
}
