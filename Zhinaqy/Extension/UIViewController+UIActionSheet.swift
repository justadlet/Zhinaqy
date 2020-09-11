//
//  UIViewController+UIActionSheet.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showDatePickerView(datePicker: UIDatePicker, completion: ((UIAlertAction) -> Void)? = nil){
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        
        actionSheet.view.addSubview(datePicker)
        
        datePicker.anchor(top: actionSheet.view.topAnchor, leading: actionSheet.view.leadingAnchor, trailing: actionSheet.view.trailingAnchor, size: CGSize(width: 0, height: 200))
        
        actionSheet.addAction(UIAlertAction(title: "Done", style: .cancel, handler: completion))
        actionSheet.view.tintColor = .main
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showPickerView(pickerView: UIPickerView, completion: ((UIAlertAction) -> Void)? = nil){
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.addSubview(pickerView)
        pickerView.anchor(top: actionSheet.view.topAnchor, leading: actionSheet.view.leadingAnchor, trailing: actionSheet.view.trailingAnchor, size: CGSize(width: 0, height: 200))
        
        actionSheet.addAction(UIAlertAction(title: "Done", style: .cancel, handler: completion))
        actionSheet.view.tintColor = .main
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func keyboardAnimation(completion: (() -> Void)?) {
        UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!, animations: completion).startAnimation()
    }
}
