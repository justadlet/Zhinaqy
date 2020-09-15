//
//  BindablePickerView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


class BindablePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var binder = Bindable<Int>(0)
    var data: [String] = []
    
    /**
        Binds picker  view with parameters
       - Parameters:
           - bindable: Bindable date that observes and changed
           - data: datasource elements
    */
    func bind(with data: [String] = [],
              with bindable: Bindable<Int>) {
        self.binder = bindable
        self.dataSource = self
        self.delegate = self
        self.data = data
        
        self.observe(for: bindable) { [weak self] (value) in
            self?.selectRow(value, inComponent: 0, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.binder.value = row
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}
