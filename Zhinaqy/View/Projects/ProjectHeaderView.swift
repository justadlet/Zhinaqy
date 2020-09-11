//
//  ProjectHeaderView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class ProjectHeaderView: UIView {
    
    enum HeaderState {
        case project
        case goal
    }
    
    let headerType: HeaderState
    let project: Project
    
    
    init(frame: CGRect, headerType: HeaderState, project: Project) {
        self.headerType = headerType
        self.project = project
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
