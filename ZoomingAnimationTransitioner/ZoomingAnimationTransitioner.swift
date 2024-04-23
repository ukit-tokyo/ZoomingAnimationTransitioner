//
//  ZoomingAnimationTransitioner.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit

final class ZoomingAnimationTransitioner: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

  private let present: Bool
  private let selectedIndexPath: IndexPath

  init(present: Bool, selectedIndexPath: IndexPath) {
    self.present = present
    self.selectedIndexPath = selectedIndexPath
    super.init()
  }

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return self
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    0.7
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if present {
      presentTransition(transitionContext: transitionContext)
    } else {
      dismissTransition(transitionContext: transitionContext)
    }
  }

  func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
    // 遷移元、遷移先、遷移中コンテナの取得
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! DetailViewController
    let containerView = transitionContext.containerView

    // 遷移元で選択されたセル内のImageを取得し、アニメーション中の ImageView へ image を引き渡す
    let cell = fromViewController.collectionView.cellForItem(at: selectedIndexPath) as! CardCell
    let animationView = UIImageView(image: cell.thumbnailView.image)
    animationView.frame = containerView.convert(cell.thumbnailView.frame, from: cell.thumbnailView.superview)
    animationView.backgroundColor = .gray
    cell.thumbnailView.alpha = 0

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
      cell.thumbnailView.alpha = 1
      animationView.removeFromSuperview()
      transitionContext.completeTransition(true)
    }
    animation.startAnimation()
  }

  func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
  }
}
