//
//  Observable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

protocol Observable {
    /**
       Bind variable
       - Parameters:
           - observable: Bindable object that listens to changes
           - completion: Handle completion
    */
    func observe<T>(for observable: Bindable<T>, with: @escaping (T) -> ())
}
