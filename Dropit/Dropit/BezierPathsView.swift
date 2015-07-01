//
//  BezierPathsView.swift
//  Dropit
//
//  Created by shadowPriest on 15/7/1.
//  Copyright (c) 2015年 hxx. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    private var bezierPaths = [String:UIBezierPath]()
    func setPath(path:UIBezierPath?,named name:String){
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        for (_,path) in bezierPaths{
            path.stroke()
        }
    }

}
