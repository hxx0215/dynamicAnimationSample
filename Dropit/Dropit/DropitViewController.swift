//
//  DropitViewController.swift
//  Dropit
//
//  Created by shadowPriest on 15/6/30.
//  Copyright (c) 2015年 hxx. All rights reserved.
//

import UIKit

class DropitViewController: UIViewController,UIDynamicAnimatorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animator.addBehavior(dropitBehavior)
    }
    struct PathName{
        static let MiddleBarrier = "Middle Barrier"
        static let Attachment = "Attachment"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = dropSize
        let barrierOrigin = CGPoint(x: gameView.bounds.midX - barrierSize.width / 2, y: gameView.bounds.midY - barrierSize.height / 2)
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropitBehavior.addBarrier(path, named: PathName.MiddleBarrier)
        gameView.setPath(path, named: PathName.MiddleBarrier)
    }
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }

    let dropitBehavior = DropitBehavior()
    var attachment: UIAttachmentBehavior?{
        willSet{
            animator.removeBehavior(attachment)
            gameView.setPath(nil, named: PathName.Attachment)
        }
        didSet{
            if attachment != nil{
                animator.addBehavior(attachment)
                attachment?.action = {[unowned self] in 
                    if let attachView = self.attachment?.items.first as? UIView{
                        let path = UIBezierPath()
                        path.moveToPoint(self.attachment!.anchorPoint)
                        path.addLineToPoint(attachView.center)
                        self.gameView.setPath(path, named: PathName.Attachment)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var gameView: BezierPathsView!
    
    
    lazy var animator : UIDynamicAnimator = {
     let lazilyCreatedDynamic =  UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedDynamic.delegate = self
        return lazilyCreatedDynamic
    }()
    

    var dropsPerRow = 10
    
    var dropSize: CGSize{
        let size = gameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    @IBAction func grapDrop(sender: UIPanGestureRecognizer) {
        let gesturePoint = sender.locationInView(gameView)
        switch sender.state{
        case .Began:
            if let viewToAttachTo = lastDropView{
                attachment = UIAttachmentBehavior(item: viewToAttachTo, attachedToAnchor: gesturePoint)
                lastDropView = nil
            }
        case .Changed:
            attachment?.anchorPoint = gesturePoint
        case .Ended:
            attachment = nil
        default:
            break
        }
    }
    var lastDropView : UIView?
    func drop(){
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let dropView = UIView(frame: frame)
        dropView.backgroundColor = UIColor.random
        
        dropitBehavior.addDrop(dropView)
        lastDropView = dropView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func removeCompletedRow(){
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: gameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        do{
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
        for _ in 0 ..< dropsPerRow{
        if let hitView = gameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil){
        if hitView.superview == gameView{
            dropsFound.append(hitView)
        }else{
            rowIsComplete = false
            }
            }
            dropFrame.origin.x += dropSize.width
            }
        if rowIsComplete{
                dropsToRemove += dropsFound
            }
        }while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        for drop in dropsToRemove{
            dropitBehavior.removeDrop(drop)
        }
    }

}

private extension CGFloat{
    static func random(max:Int)->CGFloat{
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor{
    class var random:UIColor {
        switch arc4random() % 5{
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}
