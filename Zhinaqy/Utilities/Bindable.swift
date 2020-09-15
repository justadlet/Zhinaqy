//
//  Bindable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation


public class Bindable<T> {
    
    typealias Listener = (T) -> ()
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    /**
        Initialize bindable with parameters
        - Parameters:
            - v: Initial value
     */
    init(_ v: T) {
        value = v
    }
    
    
    /**
       Bind variable
       - Parameters:
           - listener: Notifies about change and returns value in a closure
    */
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    
}
