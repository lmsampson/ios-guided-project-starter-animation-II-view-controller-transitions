//
//  Animator.swift
//  Transitions
//
//  Created by Lisa Sampson on 5/16/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit

typealias LabelProvidingVC = LabelProviding & UIViewController

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // How long should your transition run?
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // What should the animation look like
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? LabelProvidingVC,
            let toVC = transitionContext.viewController(forKey: .to) as? LabelProvidingVC,
            let toView = transitionContext.view(forKey: .to) else { return }
        
        // This is the view that holds the label we will animate from one position to the other
        let containerView = transitionContext.containerView
        
        let toViewEndFrame = transitionContext.finalFrame(for: toVC)
        
        containerView.addSubview(toView)
        toView.frame = toViewEndFrame
        toView.alpha = 0
        
        // Figure out where the label should start and where it should end up
        let fromLabel = fromVC.label!
        let toLabel = toVC.label!
        
        // Hide our REAL labels so they don't show up during the transition
        fromLabel.alpha = 0
        toLabel.alpha = 0
        
        let transitionLabelInitialFrame = containerView.convert(fromLabel.bounds, from: fromLabel)
        
        // The transitioning label will be in exactly the same initial location as the fromLabel
        let transitoningLabel = UILabel(frame: transitionLabelInitialFrame)
        transitoningLabel.textColor = .white
        transitoningLabel.font = fromLabel.font
        transitoningLabel.text = fromLabel.text
        containerView.addSubview(transitoningLabel)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration, animations: {
            let transitioningLabelEndFrame = containerView.convert(toLabel.bounds, from: toLabel)
            transitoningLabel.frame = transitioningLabelEndFrame
            toView.alpha = 1
        }) { (_) in
            toLabel.alpha = 1
            fromLabel.alpha = 1
            transitoningLabel.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
