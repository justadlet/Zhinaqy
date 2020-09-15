//
//  BindableSegmentedControl.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


class BindableSegmentedControl: UISegmentedControl {
    
    var binder = Bindable<Int>(0)
    
    /**
     Binds segmented control with parameters
       - Parameters:
           - bindable: Bindable int that observes and changed
    */
    func bind(with Bindable: Bindable<Int>) {
        self.binder = Bindable
        
        self.addTarget(self,
                       action: #selector(valueChanged),
                       for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.selectedSegmentIndex = value
        }
    }
    
    @objc func valueChanged() {
        self.binder.value = self.selectedSegmentIndex
    }
}
