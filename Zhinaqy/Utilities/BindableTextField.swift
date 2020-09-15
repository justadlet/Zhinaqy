//
//  BindableTextField.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class BindableTextField: UITextField, UITextFieldDelegate {
    
    private var binder = Bindable<String>("")
    private var maxLength: Int? = nil
    
    
    /**
     Binds text field with parameters
        - Parameters:
            - bindable: Bindable string that observes and changed
            - maxLength: Max length of the text, default = nil
            - placeholder: Placeholder text, default = "Type a text"
     */
    func bind(with bindable: Bindable<String>,
              maxLength: Int? = nil,
              placeholder: String = "Type a text") {
        
        self.binder = bindable
        self.maxLength = maxLength
        self.placeholder = placeholder
        self.delegate = self
        
        self.addTarget(self,
                       action: #selector(valueChanged),
                       for: [ .valueChanged,.editingChanged])
        self.observe(for: bindable) { [weak self] (value) in
            self?.text = value
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if let maxLength = self.maxLength {
            return count <= maxLength
        }
        
        return true
    }
    
    @objc func valueChanged() {
        self.binder.value = self.text ?? ""
    }
}
