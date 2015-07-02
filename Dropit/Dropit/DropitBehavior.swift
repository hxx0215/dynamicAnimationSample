//
//  DropitBehavior.swift
//  Dropit
//
//  Created by shadowPriest on 15/6/30.
//  Copyright (c) 2015年 hxx. All rights reserved.
//

import UIKit

class DropitBehavior: UIDynamicBehavior {
   
    let gravity = UIGravityBehavior()
    lazy var collider: UICollisionBehavior = {
        let lazilyCreateDynamic = UICollisionBehavior()
        lazilyCreateDynamic.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreateDynamic
    }()
    
    lazy var dropBehavior: UIDynamicItemBehavior = {
       let lazilyCreateDynamic = UIDynamicItemBehavior()
//        lazilyCreateDynamic.allowsRotation = false
        lazilyCreateDynamic.elasticity = 0.75
        return lazilyCreateDynamic
    }()
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addDrop(drop: UIView){
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView){
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
    func addBarrier(path: UIBezierPath,named name:String){
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
}
