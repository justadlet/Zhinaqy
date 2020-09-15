//
//  FieldTableViewCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    lazy private var textField: BindableTextField = {
        let textField = BindableTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        textField.leftViewMode = .always
        textField.placeholder = "Type a text"
        
        return textField
    }()
    
    
    
    init(placeholder: String?, bindable: Bindable<String>) {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.textField.placeholder = placeholder
        self.textField.bind(with: bindable)
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addViews() {
        self.addSubview(textField)
    }
    
    
    private func setConstraints() {
        textField.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
    }
}

