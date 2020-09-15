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
    
    lazy private var button: ProgressButton = {
        let button = ProgressButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(Color.label, for: .normal)
        button.addTarget(self, action: #selector(increment), for: .touchUpInside)
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
    
    var task: Task?
    var delegate: Progressable?
    
    
    func configure(with task: Task, with delegate: Progressable) {
        self.task = task
        self.delegate = delegate
        titleLabel.text = task.name
        
        if task.type == "habit" {
            if task.progress == task.count {
                button.setImage(UIImage(named: "done"), for: .normal)
                button.setTitle(nil, for: .normal)
            } else if task.progress == 0 {
                button.setImage(UIImage(named: "pending"), for: .normal)
                button.setTitle(nil, for: .normal)
            } else {
                button.setImage(nil, for: .normal)
                button.setTitle("\(task.progress)", for: .normal)
            }
            detailLabel.text = "\(task.progress) of \(task.count) are done • \(task.project?.name ?? "")"
        } else if task.type == "task" {
            button.setTitle(nil, for: .normal)
            button.setImage(UIImage(named: task.step ?? "pending"), for: .normal)
            detailLabel.text = "\(task.start?.string(state: .time) ?? "") • \(task.project?.name ?? "")"
        } else {
            var temp = task.start?.string(state: .time)
            temp?.append(" - ")
            temp?.append(task.end?.string(state: .time) ?? "")
            temp?.append(" • \(task.project?.name ?? "")")
            detailLabel.text = temp
            button.setTitle(nil, for: .normal)
            button.setImage(UIImage(named: "event"), for: .normal)
        }
        button.update(progress: task.currentProgress)
        addViews()
        setConstraints()
    }
    
    @objc func increment() {
        if let task = self.task {
            delegate?.increment(task: task)
        }
    }
    
    func addViews() {
        [button, titleLabel, detailLabel].forEach({ addSubview($0) })
    }
    
    
    func setConstraints() {
        button.anchor(leading: leadingAnchor,
                      padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                      size: .init(width: 32, height: 32))
        button.anchorCenter(y: centerYAnchor)
        titleLabel.anchor(top: topAnchor,
                          leading: button.trailingAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: 8, left: 16, bottom: 0, right: 20))
        detailLabel.anchor(top: titleLabel.bottomAnchor,
                           leading: button.trailingAnchor,
                           bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           padding: .init(top: 4, left: 16, bottom: 8, right: 20))
    }
    
}
