//
//  UIControl+Bindable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class BindableTextField: UITextField, UITextFieldDelegate {
    
    private var binder = Bindable<String>("")
    private var maxLength: Int? = nil
    
    func bind(with Bindable: Bindable<String>, maxLength: Int? = nil) {
        self.binder = Bindable
        self.delegate = self
        self.maxLength = maxLength
        self.addTarget(self, action: #selector(valueChanged), for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.text = value
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if let maxLength = maxLength {
            return count <= maxLength
        }
        
        return true
    }
    
    @objc func valueChanged() {
        self.binder.value = self.text ?? ""
    }
}



class BindableSwitch: UISwitch {
    
    var binder = Bindable<Bool>(false)
    
    func bind(with Bindable: Bindable<Bool>) {
        self.binder = Bindable
        self.addTarget(self, action: #selector(valueChanged), for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.isOn = value
        }
    }
    
    @objc func valueChanged() {
        self.binder.value = self.isOn
    }
}


class BindableSlider: UISlider {
    
    var binder = Bindable<Float>(0)
    
    func bind(with Bindable: Bindable<Float>) {
        self.binder = Bindable
        self.addTarget(self, action: #selector(valueChanged), for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.value = value
        }
    }
    
    @objc func valueChanged() {
        self.binder.value = self.value
    }
}


class BindableStepper: UIStepper {
    
    var binder = Bindable<Double>(0)
    
    func bind(with Bindable: Bindable<Double>) {
        self.binder = Bindable
        self.addTarget(self, action: #selector(valueChanged), for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.value = value
        }
    }
    
    @objc func valueChanged() {
        self.binder.value = self.value
    }
}





class BindableSegmentedControl: UISegmentedControl {
    
    var binder = Bindable<Int>(0)
    
    func bind(with Bindable: Bindable<Int>) {
        self.binder = Bindable
        self.addTarget(self, action: #selector(valueChanged), for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.selectedSegmentIndex = value
        }
    }
    
    @objc func valueChanged() {
        self.binder.value = self.selectedSegmentIndex
    }
}


////MARK:- TextView
public class BindableTextView: UITextView, UITextViewDelegate {

    private var binder = Bindable<String>("")
    private var placeHolder = "Type a text"
    private var maxLength: Int? = nil
    private var autoSize: Bool = false
    
    
    public func bind(with Bindable: Bindable<String>, placeHolder: String = "Type a text", maxLength: Int? = nil, autoSize: Bool = false) {
        
        self.delegate = self
        self.binder = Bindable
        self.placeHolder = placeHolder
        self.maxLength = maxLength
        self.autoSize = autoSize
        
        self.textColor = .gray
        self.text = placeHolder
        
        self.observe(for: Bindable) { [weak self] (value) in
            self?.text = value
        }
    }

    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.textColor = .gray
            textView.text = placeHolder
        }
    }

    public func textViewDidChange(_ textView: UITextView) {
        binder.value = textView.text
        self.heightAnchor.constraint(equalToConstant: self.contentSize.height).isActive = autoSize
    }
    
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        if let maxLength = maxLength {
            return numberOfChars <= maxLength
        }
        
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.textColor = .black
            textView.text = ""
        }
    }
}


class BindablePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var binder = Bindable<Int>(0)
    var data: [String] = []
    
    func bind(with data: [String] = [], with Bindable: Bindable<Int>) {
        self.binder = Bindable
        self.dataSource = self
        self.delegate = self
        self.data = data
        self.observe(for: Bindable) { [weak self] (value) in
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


public class BindableDatePicker: UIDatePicker {

    var binder = Bindable<Date>(Date())

    public func bind(with Bindable: Bindable<Date>) {
        self.binder = Bindable
        self.addTarget(self, action: #selector(valueChanged), for: [ .valueChanged,.editingChanged])
        self.observe(for: Bindable) { [weak self] (value) in
            self?.date = value
        }
    }

    
    @objc func valueChanged() {
        self.binder.value = self.date
    }
}


public class BindableLabel<T>: UILabel {
    
    public func bind(with observable: Bindable<T>, with decoder: @escaping(T) -> String) {
        observable.bind { value  in
            DispatchQueue.main.async {
                self.text = decoder(value)
            }
        }
    }
    
}

