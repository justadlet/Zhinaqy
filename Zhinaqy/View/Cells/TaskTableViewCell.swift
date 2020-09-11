//
//  TaskTableViewCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    static let reuseId = "taskCell"
    
    lazy private var button: UIButton = {
        let button = UIButton()
        button.setTitle("AS", for: .normal)
        button.setTitleColor(.main, for: .normal)
        return button
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    
    
    func configure(with task: Task) {
        titleLabel.text = task.name
        detailLabel.text = task.start?.string(state: .time)
        addViews()
        setConstraints()
    }
    
    
    func addViews() {
        [button, titleLabel, detailLabel].forEach({ addSubview($0) })
    }
    
    
    func setConstraints() {
        button.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0), size: CGSize(width: 32, height: 0))
        titleLabel.anchor(top: topAnchor, leading: button.trailingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 20))
        detailLabel.anchor(top: titleLabel.bottomAnchor, leading: button.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 4, left: 16, bottom: 8, right: 20))
    }
    
}
