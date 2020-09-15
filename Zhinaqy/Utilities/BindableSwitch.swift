//
//  BindableSwitch.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


class BindableSwitch: UISwitch {
    
    var binder = Bindable<Bool>(false)
    
    /**
     Binds switch with parameters
       - Parameters:
           - bindable: Bindable bool that observes and changed
    */
    func bind(with Bindable: Bindable<Bool>) {
        self.binder = Bindable
        
        self.addTarget(self,
                       action: #selector(valueChanged),
                       for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.isOn = value
        }
    }
    
    @objc func valueChanged() {
        self.binder.value = self.isOn
    }
}
