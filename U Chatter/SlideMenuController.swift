//
//  SlideMenuController.swift
//  U Chatter
//
//  Created by Harrison McGuire on 12/16/14.
//  Copyright (c) 2014 harrisonmcguire. All rights reserved.
//
//  SlideMenuController.swift
//  Created by Yuji Hato on 12/3/14.
//  This script was originally created by Yuji Hato. I adopted it and altered it.

import Foundation
import UIKit

enum SlideAction {
    case Open,
    Close
}


struct PanInfo {
    var action: SlideAction
    var shouldBounce: Bool
    var velocity: CGFloat
}

class SlideMenuOption {
    
    let leftViewOverlapWidth: CGFloat = 150.0
    let leftBezelWidth: CGFloat = 16.0
    let contentViewScale: CGFloat = 0.85
    let contentViewOpacity: CGFloat = 0.5
    let shadowOpacity: CGFloat = 0.0
    let shadowRadius: CGFloat = 0.0
    let shadowOffset: CGSize = CGSizeMake(0,0)
    let panFromBezel: Bool = true
    let animationDuration: CGFloat = 0.4

    let hideStatusBar: Bool = false

    init() {
        
    }
}


class SlideMenuController: UIViewController, UIGestureRecognizerDelegate {
    
    
    var opacityView = UIView()
    var mainContainerView = UIView()
    var leftContainerView = UIView()
    var mainViewController: UIViewController?
    var leftViewController: UIViewController?
    var leftPanGesture: UIPanGestureRecognizer?
    var leftTapGetsture: UITapGestureRecognizer?

    var options = SlideMenuOption()
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController) {
        self.init()
        self.mainViewController = mainViewController
        self.leftViewController = leftMenuViewController
        self.initView()
    }
    
    deinit { }
    
    func initView() {
        mainContainerView = UIView(frame: self.view.bounds)
        mainContainerView.backgroundColor = UIColor.clearColor()
        mainContainerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.view.insertSubview(mainContainerView, atIndex: 1)
        
        var opacityframe: CGRect = self.view.bounds
        var opacityOffset: CGFloat = 0
        opacityframe.origin.y = opacityframe.origin.y + opacityOffset
        opacityframe.size.height = opacityframe.size.height - opacityOffset
        opacityView = UIView(frame: opacityframe)
        //opacityView.backgroundColor = UIColor.blueColor()
        opacityView.backgroundColor = UIColor(patternImage: UIImage(named: "menuback1")!)
        opacityView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        opacityView.layer.opacity = 0.0
        self.view.insertSubview(opacityView, atIndex: 0)
        
        var leftFrame: CGRect = self.view.bounds
        leftFrame.size.width = CGRectGetWidth(self.view.bounds) - self.options.leftViewOverlapWidth
        //leftFrame.size.width = 320.0 - self.options.leftViewOverlapWidth
        leftFrame.origin.x = self.minLeftOrigin();
        var leftOffset: CGFloat = 0
        leftFrame.origin.y = leftFrame.origin.y + leftOffset
        leftFrame.size.height = leftFrame.size.height - leftOffset
        leftContainerView = UIView(frame: leftFrame)
        leftContainerView.backgroundColor = UIColor.clearColor()
        leftContainerView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.view.insertSubview(leftContainerView, atIndex: 1)
        
        self.addGestures()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    override func viewWillLayoutSubviews() {
        // topLayoutGuide
        self.setUpViewController(self.mainContainerView, targetViewController: self.mainViewController)
        self.setUpViewController(self.leftContainerView, targetViewController: self.leftViewController)
    }
    
    // Notification func for view close
    func handleWillEnterForegroundNotification(notif: NSNotification) {
        self.closeLeft()
    }
    
    override func openLeft() {
        self.setOpenWindowLevel()
        
        //leftViewControllerviewWillAppear
        self.leftViewController?.beginAppearanceTransition(self.isLeftHidden(), animated: true)
        self.openLeftWithVelocity(0.0)
    }
    
    override func closeLeft() {
        self.closeLeftWithVelocity(0.0)
        self.setCloseWindowLebel()
    }
    
    func addGestures() {
        
       if (self.leftViewController != nil) {
            if self.leftPanGesture == nil {
                self.leftPanGesture = UIPanGestureRecognizer(target: self, action: "handleLeftPanGesture:")
                self.leftPanGesture!.delegate = self
                self.view.addGestureRecognizer(self.leftPanGesture!)
            }

            if self.leftTapGetsture == nil {
                self.leftTapGetsture = UITapGestureRecognizer(target: self, action: "toggleLeft")
                self.leftTapGetsture!.delegate = self
                self.view.addGestureRecognizer(self.leftTapGetsture!)
            }

        }

    }

    func removeGestures() {
        
        if self.leftPanGesture != nil {
            self.view.removeGestureRecognizer(self.leftPanGesture!)
            self.leftPanGesture = nil
        }

        if self.leftTapGetsture != nil {
            self.view.removeGestureRecognizer(self.leftTapGetsture!)
            self.leftTapGetsture = nil
        }
        
    }
    
    func isTagetViewController() -> Bool {
        return true
    }
    
    func handleLeftPanGesture(panGesture: UIPanGestureRecognizer) {
        if let url = NSURL(fileURLWithPath: "xxx") {
            if NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
                
            }
        }
        
        if !self.isTagetViewController() {
            return
        }
        
        var menuFrameAtStartOfPan: CGRect = self.leftContainerView.frame
        var startPointOfPan: CGPoint = panGesture.locationInView(self.view)
        var menuWasOpenAtStartOfPan: Bool = self.isLeftOpen()
        var menuWasHiddenAtStartOfPan: Bool = self.isLeftHidden()
        
        switch panGesture.state {
        case UIGestureRecognizerState.Began:
            
            menuFrameAtStartOfPan = self.leftContainerView.frame
            startPointOfPan = panGesture.locationInView(self.view)
            menuWasOpenAtStartOfPan = self.isLeftOpen()
            menuWasHiddenAtStartOfPan = self.isLeftHidden()
            self.leftViewController?.beginAppearanceTransition(menuWasHiddenAtStartOfPan, animated: true)
            self.addShadowToView(self.leftContainerView)
            self.setOpenWindowLevel()
        case UIGestureRecognizerState.Changed:
            
            var translation: CGPoint = panGesture.translationInView(panGesture.view!)
            self.leftContainerView.frame = self.applyLeftTranslation(translation, toFrame: menuFrameAtStartOfPan)
            self.applyLeftOpacity()
            self.applyLeftContentViewScale()
        case UIGestureRecognizerState.Ended:
            
            self.leftViewController?.beginAppearanceTransition(!menuWasHiddenAtStartOfPan, animated: true)
            var velocity:CGPoint = panGesture.velocityInView(panGesture.view)
            var panInfo: PanInfo = self.panLeftResultInfoForVelocity(velocity)
            
            if panInfo.action == SlideAction.Open {
                self.openLeftWithVelocity(panInfo.velocity)
            } else {
                self.closeLeftWithVelocity(panInfo.velocity)
                self.setCloseWindowLebel()
            }
            break
        default:
            break
        }
        
    }

    func openLeftWithVelocity(velocity: CGFloat) {
        var xOrigin: CGFloat = self.leftContainerView.frame.origin.x
        var finalXOrigin: CGFloat = 0.0
        
        var frame = self.leftContainerView.frame;
        frame.origin.x = finalXOrigin;
        
        var duration: NSTimeInterval = Double(self.options.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        self.addShadowToView(self.leftContainerView)
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftContainerView.frame = frame
            self.opacityView.layer.opacity = Float(self.options.contentViewOpacity)
            self.mainContainerView.transform = CGAffineTransformScale(self.offStage(200), self.options.contentViewScale, self.options.contentViewScale)
            }) { (Bool) -> Void in
                self.disableContentInteraction()
        }
    }
    
    
    func closeLeftWithVelocity(velocity: CGFloat) {
        
        var xOrigin: CGFloat = self.leftContainerView.frame.origin.x
        var finalXOrigin: CGFloat = self.leftMinOrigin()
        
        var frame: CGRect = self.leftContainerView.frame;
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(self.options.animationDuration)
        if velocity != 0.0 {
            duration = Double(fabs(xOrigin - finalXOrigin) / velocity)
            duration = Double(fmax(0.1, fmin(1.0, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.leftContainerView.frame = frame
            self.opacityView.layer.opacity = 0.0
            self.mainContainerView.transform = CGAffineTransformScale(self.offStage(0),1.0, 1.0)
            }) { (Bool) -> Void in
                self.removeShadow(self.leftContainerView)
                self.enableContentInteraction()
        }
    }
    
    override func toggleLeft() {
        if self.isLeftOpen() {
            self.closeLeft()
            self.setCloseWindowLebel()
        } else {
            self.openLeft()
        }
    }
    
    func isLeftOpen() -> Bool {
        return self.leftContainerView.frame.origin.x == 0.0
    }
    
    func isLeftHidden() -> Bool {
        return self.leftContainerView.frame.origin.x <= self.leftMinOrigin()
    }

    func changeMainViewController(mainViewController: UIViewController,  close: Bool) {
        
        self.mainViewController = mainViewController
        if (close) {
            self.closeLeft()
        }
    }
    
    func changeLeftViewController(leftViewController: UIViewController, closeLeft:Bool) {
        self.leftViewController = leftViewController
        if (closeLeft) {
            self.closeLeft()
        }
    }

    private func leftMinOrigin() -> CGFloat {
        //return  -320.0 + self.options.leftViewOverlapWidth
        return -(CGRectGetWidth(self.view.bounds) - self.options.leftViewOverlapWidth)
    }
    
    private func panLeftResultInfoForVelocity(velocity: CGPoint) -> PanInfo {
        
        var thresholdVelocity: CGFloat = 450.0
        var pointOfNoReturn: CGFloat = CGFloat(floor(self.leftMinOrigin() / 2.0))
        var leftOrigin: CGFloat = self.leftContainerView.frame.origin.x
        
        var panInfo: PanInfo = PanInfo(action: SlideAction.Close, shouldBounce: false, velocity: 0.0)
        
        panInfo.action = leftOrigin <= pointOfNoReturn ? SlideAction.Close : SlideAction.Open;
        
        if velocity.x >= thresholdVelocity {
            panInfo.action = SlideAction.Open
            panInfo.velocity = velocity.x
        } else if velocity.x <= (-1.0 * thresholdVelocity) {
            panInfo.action = SlideAction.Close
            panInfo.velocity = velocity.x
        }
        
        return panInfo
    }

    private func applyLeftTranslation(translation: CGPoint, toFrame:CGRect) -> CGRect {
        
        var newOrigin: CGFloat = toFrame.origin.x
        newOrigin += translation.x
        
        var minOrigin: CGFloat = self.leftMinOrigin()
        var maxOrigin: CGFloat = 0.0
        var newFrame: CGRect = toFrame
        
        if newOrigin < minOrigin {
            newOrigin = minOrigin
        } else if newOrigin > maxOrigin {
            newOrigin = maxOrigin
        }
        
        newFrame.origin.x = newOrigin
        return newFrame
    }

    private func getOpenedLeftRatio() -> CGFloat {
        
        var width: CGFloat = self.leftContainerView.frame.size.width
        var currentPosition: CGFloat = self.leftContainerView.frame.origin.x - self.leftMinOrigin()
        return currentPosition / width
    }

    private func applyLeftOpacity() {
        
        var openedLeftRatio: CGFloat = self.getOpenedLeftRatio()
        var opacity: CGFloat = self.options.contentViewOpacity * openedLeftRatio
        self.opacityView.layer.opacity = Float(opacity)
    }
    
    private func applyLeftContentViewScale() {
        var openedLeftRatio: CGFloat = self.getOpenedLeftRatio()
        var scale: CGFloat = 1.0 - ((1.0 - self.options.contentViewScale) * openedLeftRatio);
        self.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale)
    }

    private func addShadowToView(targetContainerView: UIView) {
        targetContainerView.layer.masksToBounds = false
        targetContainerView.layer.shadowOffset = self.options.shadowOffset
        targetContainerView.layer.shadowOpacity = Float(self.options.shadowOpacity)
        targetContainerView.layer.shadowRadius = self.options.shadowRadius
        targetContainerView.layer.shadowPath = UIBezierPath(rect: targetContainerView.bounds).CGPath
    }
    
    private func removeShadow(targetContainerView: UIView) {
        targetContainerView.layer.masksToBounds = true
        self.mainContainerView.layer.opacity = 1.0
    }
    
    private func removeContentOpacity() {
        self.opacityView.layer.opacity = 0.0
    }
    
    
    private func addContentOpacity() {
        self.opacityView.layer.opacity = Float(self.options.contentViewOpacity)
    }
    
    private func disableContentInteraction() {
        self.mainContainerView.userInteractionEnabled = false
    }
    
    private func enableContentInteraction() {
        self.mainContainerView.userInteractionEnabled = true
    }
    
    private func setOpenWindowLevel() {
        if (self.options.hideStatusBar) {
            dispatch_async(dispatch_get_main_queue(), {
                if let window = UIApplication.sharedApplication().keyWindow {
                    window.windowLevel = UIWindowLevelStatusBar + 1
                }
            })
        }
    }
    
    private func setCloseWindowLebel() {
        if (self.options.hideStatusBar) {
            dispatch_async(dispatch_get_main_queue(), {
                if let window = UIApplication.sharedApplication().keyWindow {
                    window.windowLevel = UIWindowLevelNormal
                }
            })
        }
    }
    
    private func setUpViewController(taretView: UIView, targetViewController: UIViewController?) {
        if let viewController = targetViewController {
            self.addChildViewController(viewController)
            viewController.view.frame = taretView.bounds
            taretView.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
        }
    }
    
    
    private func removeViewController(viewController: UIViewController?) {
        if let _viewController = viewController {
            _viewController.willMoveToParentViewController(nil)
            _viewController.view.removeFromSuperview()
            _viewController.removeFromParentViewController()
        }
    }
    
    private func minLeftOrigin() -> CGFloat{
        //return  -320.0 + self.options.leftViewOverlapWidth
        return  self.options.leftViewOverlapWidth - CGRectGetWidth(self.view.bounds)
    }
    
    private func minRightOrigin() -> CGFloat {
        return CGRectGetWidth(self.view.bounds)
    }

    //pragma mark – UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        var point: CGPoint = touch.locationInView(self.view)
        
        if gestureRecognizer == self.leftPanGesture {
            return self.slideLeftForGestureRecognizer(gestureRecognizer, point: point)
        } else if gestureRecognizer == self.leftTapGetsture {
            return self.isLeftOpen() && !self.isPointContainedWithinLeftRect(point)
        }
        
        return true
    }

    private func slideLeftForGestureRecognizer( gesture: UIGestureRecognizer, point:CGPoint) -> Bool{
        
        var slide = self.isLeftOpen()
        slide |= self.options.panFromBezel && self.isLeftPointContainedWithinBezelRect(point)
        return slide
    }
    
    private func isLeftPointContainedWithinBezelRect(point: CGPoint) -> Bool{
        var leftBezelRect: CGRect = CGRectZero
        var tempRect: CGRect = CGRectZero
        var bezelWidth: CGFloat = self.options.leftBezelWidth
        
        CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, bezelWidth, CGRectEdge.MinXEdge)
        return CGRectContainsPoint(leftBezelRect, point)
    }
    
    private func isPointContainedWithinLeftRect(point: CGPoint) -> Bool {
        return CGRectContainsPoint(self.leftContainerView.frame, point)
    }

}


extension UIViewController {
    
    func slideMenuController() -> SlideMenuController? {
        var viewController: UIViewController? = self
        while viewController != nil {
            if viewController is SlideMenuController {
                return viewController as? SlideMenuController
            }
            viewController = viewController?.parentViewController
        }
        return nil;
    }
    
    func addLeftBarButtonWithImage(buttonImage: UIImage) {
        var leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.Bordered, target: self, action: "toggleLeft")
        self.navigationItem.leftBarButtonItem = leftButton;
    }

    public func toggleLeft() {
        self.slideMenuController()?.toggleLeft()
    }

    func openLeft() {
        self.slideMenuController()?.openLeft()
    }

    func closeLeft() {
        self.slideMenuController()?.closeLeft()
    }

    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
}

