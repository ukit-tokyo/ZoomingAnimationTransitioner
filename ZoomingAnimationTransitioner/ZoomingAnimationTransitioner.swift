//
//  ZoomingAnimationTransitioner.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit

protocol ZoomingAnimationTransitionable where Self: UIViewController {
  var imageView: UIImageView { get }
}

final class ZoomingAnimationTransitioner<Presented: ZoomingAnimationTransitionable>:
  NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
  private let present: Bool
  private let fromImageView: UIImageView

  init(present: Bool, from fromImageView: UIImageView) {
    self.present = present
    self.fromImageView = fromImageView
    super.init()
  }

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if present {
      presentTransition(transitionContext: transitionContext)
    } else {
      dismissTransition(transitionContext: transitionContext)
    }
  }

  private func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
    let toViewController = transitionContext.viewController(forKey: .to) as! Presented
    let containerView = transitionContext.containerView

    let animationView = UIImageView(image: fromImageView.image)
    animationView.frame = containerView.convert(fromImageView.frame, from: fromImageView.superview)
    animationView.backgroundColor = .gray
    fromImageView.alpha = 0

    // 遷移先の VC を予め最後の位置まで移動させ非表示にする
    toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
    toViewController.view.layoutIfNeeded()
    toViewController.view.alpha = 0
    // アニメーションが完了するまで遷移先のImageViewは非表示にする
    toViewController.imageView.isHidden = true

    // 遷移中コンテナに、遷移後のビューと、アニメーション用のビューを追加する
    containerView.addSubview(toViewController.view)
    containerView.addSubview(animationView)

    let animation = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.8) {
      toViewController.view.alpha = 1.0
      animationView.frame = containerView.convert(toViewController.imageView.frame, from: toViewController.view)
    }
    animation.addCompletion { _ in
      toViewController.imageView.isHidden = false
      self.fromImageView.alpha = 1
      animationView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
    animation.startAnimation()
  }

  private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
  }
}
