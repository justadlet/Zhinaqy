//
//  AlertCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class AlertCell: UICollectionViewCell {
    
    lazy private var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy private var removeImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "xmark"))
        return imageView
    }()
    
    static let reuseId = "alertCell"
    
    func configure(alert: Date) {
        timeLabel.text = alert.string(state: .time)
        setUI()
        addViews()
        setConstraints()
    }
    
    
    func setUI() {
        backgroundColor = .main
        layer.cornerRadius = 8
    }
    
    
    func addViews() {
        self.addSubview(timeLabel)
        self.addSubview(removeImage)
    }
    
    
    func setConstraints() {
        timeLabel.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         padding: .init(top: 8, left: 12, bottom: 8, right: 4))
        removeImage.anchor(top: topAnchor,
                           leading: timeLabel.trailingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           padding: .init(top: 8, left: 4, bottom: 8, right: 12),
                           size: .init(width: 20, height: 20))
    }
    
}
