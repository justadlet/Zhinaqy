//
//  ProjectHeaderView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

enum HeaderState {
    case project
    case goal
}

class ProjectHeaderView: UIView {
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    lazy private var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    lazy private var segmentedControl: BindableSegmentedControl = {
        let control = BindableSegmentedControl()
        control.bind(with: self.selectedIndex)
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    
    let headerType: HeaderState
    let selectedIndex: Bindable<Int>
    
    init(frame: CGRect,
         headerType: HeaderState,
         project: Project,
         selectedIndex: Bindable<Int>,
         segments: [String]) {
        
        self.headerType = headerType
        self.selectedIndex = selectedIndex
        
        super.init(frame: frame)
        
        for (num, segment) in segments.enumerated() {
            self.segmentedControl.insertSegment(withTitle: segment,
                                                at: num,
                                                animated: true)
        }
        self.detailsLabel.text = "Deadline: \(project.deadline?.string(state: .dateTime) ?? "")"
        self.titleLabel.text = project.name
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addViews() {
        self.addSubview(titleLabel)
        if headerType == .goal {
            self.addSubview(detailsLabel)
        }
        self.addSubview(segmentedControl)
    }
    
    
    func setConstraints() {
        switch headerType {
        case .project:
            titleLabel.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 16,
                                                    left: 16,
                                                    bottom: 0,
                                                    right: 16))
            segmentedControl.anchor(top: titleLabel.bottomAnchor,
                                    leading: leadingAnchor,
                                    bottom: bottomAnchor,
                                    trailing: trailingAnchor,
                                    padding: UIEdgeInsets(top: 8,
                                                          left: 16,
                                                          bottom: 16,
                                                          right: 16))
        case .goal:
            titleLabel.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 16,
                                                    left: 16,
                                                    bottom: 0,
                                                    right: 16))
            detailsLabel.anchor(top: titleLabel.bottomAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                padding: UIEdgeInsets(top: 8,
                                                      left: 16,
                                                      bottom: 0,
                                                      right: 16))
            segmentedControl.anchor(top: detailsLabel.bottomAnchor,
                                    leading: leadingAnchor,
                                    bottom: bottomAnchor,
                                    trailing: trailingAnchor,
                                    padding: UIEdgeInsets(top: 8,
                                                          left: 16,
                                                          bottom: 16,
                                                          right: 16))
        }
        
    }
}
