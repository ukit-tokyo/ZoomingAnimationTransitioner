//
//  ZoomingAnimationTransitioner.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit

final class ZoomingAnimationTransitioner: NSObject {
  enum TransitionType {
    case show, back
  }
  var transitionType: TransitionType = .back
  private weak var selectedImageView: UIImageView!
  private weak var detailImageView: UIImageView!

  init(from selectedImageView: UIImageView, to detailImageView: UIImageView) {
    self.selectedImageView = selectedImageView
    self.detailImageView = detailImageView
    super.init()
  }
}

extension ZoomingAnimationTransitioner: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transitionType = .show
    return self
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transitionType = .back
    return self
  }
}

extension ZoomingAnimationTransitioner: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if transitionType == .show {
      presentTransition(transitionContext: transitionContext)
    } else {
      dismissTransition(transitionContext: transitionContext)
    }
  }

  private func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
    let containerView = transitionContext.containerView

    let animationView = UIImageView(image: selectedImageView.image)
    animationView.frame = containerView.convert(selectedImageView.frame, from: selectedImageView.superview)
    animationView.backgroundColor = .gray

    toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
    toViewController.view.layoutIfNeeded()
    toViewController.view.alpha = 0

    selectedImageView.alpha = 0
    detailImageView.alpha = 0

    containerView.addSubview(toViewController.view)
    containerView.addSubview(animationView)

    var rect = containerView.convert(detailImageView.frame, from: detailImageView.superview)
    let navigationController = (toViewController as? UINavigationController) ?? toViewController.navigationController
    if let navigationBarHeight = navigationController?.navigationBar.bounds.height,
       let statusBarHeight = toViewController.view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
      rect.origin.y += navigationBarHeight
      rect.origin.y += statusBarHeight
    }

    let animation = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1.0) {
      toViewController.view.alpha = 1.0
      animationView.frame = rect
    }
    animation.addCompletion { _ in
      self.detailImageView.alpha = 1
      self.selectedImageView.alpha = 1
      animationView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
    animation.startAnimation()
  }

  private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to),
          let fromViewController = transitionContext.viewController(forKey: .from) else { return }

    let containerView = transitionContext.containerView

    guard let animationView = detailImageView.snapshotView(afterScreenUpdates: false) else { return }
    animationView.frame = containerView.convert(detailImageView.frame, from: detailImageView.superview)
    animationView.backgroundColor = .gray

    detailImageView.alpha = 0
    selectedImageView.alpha = 0

    containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
    containerView.addSubview(animationView)

    let animation = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 1.0) {
      fromViewController.view.alpha = 0
      animationView.frame = containerView.convert(self.selectedImageView.frame, from: self.selectedImageView.superview)
    }
    animation.addCompletion { _ in
      self.detailImageView.alpha = 1
      self.selectedImageView.alpha = 1
      animationView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
    animation.startAnimation()
  }
}
