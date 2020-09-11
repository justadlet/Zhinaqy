//
//  Result.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

enum Result<A> {
    case success(data: A)
    case failure(message: String)
}
