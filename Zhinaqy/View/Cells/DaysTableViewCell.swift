//
//  DaysTableViewCell.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class DaysTableViewCell: UITableViewCell {

    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: Calendar.current.shortWeekdaySymbols.map({ (day) -> UIButton in
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setTitle(day.uppercased(), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
            button.layer.cornerRadius = 12
            button.backgroundColor = self.selectedDays.value.contains(day) ? UIColor.main : UIColor.clear
            button.tag = Calendar.current.shortWeekdaySymbols.firstIndex(of: day)!
            button.addTarget(self, action: #selector(selectDay), for: .touchDown)
            return button
        }))
        stackView.spacing = 8.0
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    
    var selectedDays: Bindable<[String]>
    
    
    init(bindable: Bindable<[String]>) {
        selectedDays = bindable
        
        super.init(style: .default, reuseIdentifier: nil)
        
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func addViews()  {
        addSubview(stackView)
    }
    
    
    func setConstraints() {
        stackView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: 8, left: 16, bottom: 8, right: 16))
    }

    
    
    @objc func selectDay(sender: UIButton) {
        let day = Calendar.current.shortWeekdaySymbols[sender.tag]
        if let index = selectedDays.value.firstIndex(of: day) {
            selectedDays.value.remove(at: index)
        }  else {
            selectedDays.value.append(day)
        }
    }
}
