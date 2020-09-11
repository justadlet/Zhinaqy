//
//  TextViewTableViewCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    lazy private var textView: BindableTextView = {
        let textView = BindableTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17)
        
        return textView
    }()
    
    
    
    init(placeholder: String?, bindable: Bindable<String>) {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.textView.bind(with: bindable, placeHolder: "Comments", autoSize: true)
        self.addViews()
        self.setConstraints()
    }
    
    
    private func addViews() {
        self.addSubview(textView)
    }
    
    private func setConstraints() {
        textView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 20, bottom: 8, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
