//
//  BindableTextView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


public class BindableTextView: UITextView, UITextViewDelegate {

    private var binder = Bindable<String>("")
    private var placeHolder = "Type a text"
    private var maxLength: Int? = nil
    
    
    /**
     Binds switch with parameters
       - Parameters:
           - bindable: Bindable string that observes and changed
           - placeHolder: Placeholder text, default = "Type a text"
           - maxLength : Max length of the text, default = nil
    */
    public func bind(with bindable: Bindable<String>,
                     placeHolder: String = "Type a text",
                     maxLength: Int? = nil) {
        
        self.delegate = self
        self.textColor = bindable.value.count == 0 ? Color.secondaryLabel : Color.label
        self.text = bindable.value.count == 0 ? placeHolder : bindable.value
        
        self.binder = bindable
        self.placeHolder = placeHolder
        self.maxLength = maxLength
        
        self.observe(for: bindable) { [weak self] (value) in
            self?.text = value
        }
    }

    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.textColor = Color.secondaryLabel
            textView.text = placeHolder
        }
    }

    
    public func textViewDidChange(_ textView: UITextView) {
        binder.value = textView.text
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
        if textView.textColor == Color.secondaryLabel {
            textView.textColor = Color.label
            textView.text = ""
        }
    }
}
