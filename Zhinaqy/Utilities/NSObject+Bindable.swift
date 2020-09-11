//
//  NSObject+Observable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

extension NSObject {
    public func observe<T>(for observable: Bindable<T>, with: @escaping (T) -> ()) {
        observable.bind { value  in
            DispatchQueue.main.async {
                with(value)
            }
        }
    }
}
