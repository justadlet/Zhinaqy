//
//  SectionHeader.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/12/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    
    lazy private var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.secondarySystemBackground
        view.layer.cornerRadius = 11
        return view
    }()
    
    
    
    init(date: Date) {
        super.init(reuseIdentifier: nil)
        titleLabel.text = "\(date.string(state: .monthDay)) • \(date.string(state: .weekDay).capitalized)"
        
        titleLabel.textColor = Color.label
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addViews() {
        self.backView.addSubview(titleLabel)
        self.addSubview(backView)
    }
    
    
    func setConstraints() {
        backView.anchor(top: topAnchor,
                        leading: leadingAnchor,
                        bottom: bottomAnchor,
                        padding: .init(top: 8, left: 20, bottom: 8, right: 0))
        titleLabel.anchor(top: backView.topAnchor,
                          leading: backView.leadingAnchor,
                          bottom: backView.bottomAnchor,
                          trailing: backView.trailingAnchor,
                          padding: .init(top: 3, left: 8, bottom: 3, right: 8))
    }
}
