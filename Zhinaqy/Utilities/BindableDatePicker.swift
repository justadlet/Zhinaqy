//
//  BindableDatePicker.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

public class BindableDatePicker: UIDatePicker {

    var binder = Bindable<Date>(Date())

    /**
        Binds date picker with parameters
       - Parameters:
           - Bindable: Bindable date that observes and changed
    */
    public func bind(with Bindable: Bindable<Date>) {
        self.binder = Bindable
        
        self.addTarget(self,
                       action: #selector(valueChanged),
                       for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.date = value
        }
    }

    
    @objc func valueChanged() {
        self.binder.value = self.date
    }
}
