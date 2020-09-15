//
//  UIView+Anchor.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/10/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


extension UIView {
    
    /**
        Sets constant width and height
     */
    func anchorSize(to frame: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
    
    /**
       Sets constant x and y centers
    */
    func anchorCenter(x: NSLayoutXAxisAnchor? = nil,  y: NSLayoutYAxisAnchor? = nil, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let x = x {
            centerXAnchor.constraint(equalTo: x, constant: size.width).isActive = true
        }
        
        if let y = y {
            centerYAnchor.constraint(equalTo: y, constant: size.height).isActive = true
        }
    }
    
    
    /**
       Sets constant top, right, bottom and left constraints
        - Parameters:
            - top: Top constraint
            - bottom: Bottom constraint
            - right: Right constraint
            - left: Left constraint
            - padding: Set padding to view, default = .zero
            - size: Sets constant size, default = .zero
    */
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
}
