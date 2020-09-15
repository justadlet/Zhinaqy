//
//  UIButton+Path.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/13/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


public class ProgressButton: UIButton {
    
    let progressLyr = CAShapeLayer()
    var progress: CGFloat = 0.0
    lazy var circlePath: UIBezierPath = {
        return UIBezierPath(
                    arcCenter: CGPoint(x: self.frame.size.width/2,
                                       y: self.frame.size.height/2),
                    radius: (self.frame.size.width - 1.5)/2,
                    startAngle: CGFloat(-0.5 * .pi),
                    endAngle: CGFloat(1.5 * .pi),
                    clockwise: true)
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addViews() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2
        self.progressLyr.path = circlePath.cgPath
        self.progressLyr.fillColor = UIColor.clear.cgColor
        self.progressLyr.strokeColor = UIColor.main.cgColor
        self.progressLyr.lineWidth = 3.0
        self.progressLyr.strokeEnd = 0.0
        self.layer.addSublayer(progressLyr)
    }
    
    func update(progress: CGFloat) {
        self.progressLyr.strokeEnd = progress
        self.progress = progress
    }
    
}
