//
//  DayCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    static let reuseId = "dayCell"
    
    lazy private var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.anchorSize(to: CGSize(width: 32, height: 32))
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    
    
    func configure(day: Day, currentDay: Bool = false) {
        self.dayLabel.text = "\(day.date.element(.day))"
        
        self.dayLabel.textColor = (!currentDay && day.date.same(.day, as: Date())) ? Color.main : Color.label
        if currentDay {
            self.dayLabel.font = .systemFont(ofSize: 17, weight: .bold)
        } else if day.date.same(.day, as: Date()) {
            self.dayLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        } else {
            self.dayLabel.font = .systemFont(ofSize: 17, weight: .regular)
        }
        
        self.dayLabel.backgroundColor = currentDay ? Color.main : UIColor.clear
        addViews()
        setConstraints()
    }
    
    func addViews() {
        self.addSubview(dayLabel)
    }
    
    
    func setConstraints() {
        dayLabel.anchorCenter(x: centerXAnchor, y: centerYAnchor)
    }
    
    
    override func prepareForReuse() {
        self.dayLabel.removeFromSuperview()
    }
}
