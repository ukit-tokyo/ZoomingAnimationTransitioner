//
//  ZoomingAnimationNavigationController.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit

protocol ZoomingAnimationDestinatable where Self: UIViewController {}

final class ZoomingAnimationNavigationController: UINavigationController {
  private let zoomAnimationDelegate = ZoomingAnimationNavigationControllerDelegate()

  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    delegate = zoomAnimationDelegate
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    delegate = zoomAnimationDelegate
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    delegate = zoomAnimationDelegate
  }

  func set(from selectedImageView: UIImageView, to detailImageView: UIImageView) {
    zoomAnimationDelegate.selectedImageView = selectedImageView
    zoomAnimationDelegate.detailImageView = detailImageView
  }
}

// MARK: -

final class ZoomingAnimationNavigationControllerDelegate: NSObject {
  weak var selectedImageView: UIImageView?
  weak var detailImageView: UIImageView?

  private var zoomingInteractiveTransition: ZoomingInteractiveTransition?

//  private let backSwipeGesture: SwipeGestureRecognizer = {
//    let gesture = SwipeGestureRecognizer()
//    gesture.direction = .right
//    return gesture
//  }()
}

extension ZoomingAnimationNavigationControllerDelegate: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {

    guard let selectedImageView, let detailImageView else { return nil }

    let transitioner = ZoomingAnimationTransitioner(from: selectedImageView, to: detailImageView)
    switch operation {
    case .push:
      zoomingInteractiveTransition = ZoomingInteractiveTransition(viewController: toVC)
      transitioner.transitionType = .show
    case .pop: transitioner.transitionType = .back
    default: return nil
    }
    return transitioner
  }

  func navigationController(
    _ navigationController: UINavigationController,
    interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
  ) -> UIViewControllerInteractiveTransitioning? {
    guard let interactor = zoomingInteractiveTransition else { return nil }
    print("testing___", interactor.isTransitioning ? interactor : nil)
    return interactor.isTransitioning ? interactor : nil
  }

//  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//    backSwipeGesture.navigationController = navigationController
//    backSwipeGesture.addTarget(self, action: #selector(handleSwipe(_:)))
//    navigationController.view.addGestureRecognizer(backSwipeGesture)
//  }

//  @objc func handleSwipe(_ sender: SwipeGestureRecognizer) {
//    sender.navigationController?.popViewController(animated: true)
//  }
}

//final class SwipeGestureRecognizer: UISwipeGestureRecognizer {
//  weak var navigationController: UINavigationController?
//}

// MARK: -

final class ZoomingInteractiveTransition: UIPercentDrivenInteractiveTransition {
  private let navigationController: UINavigationController
  private(set) var isTransitioning: Bool = false

  init?(viewController: UIViewController) {
    guard let navigationController = viewController.navigationController else { return nil }
    self.navigationController = navigationController
    super.init()
    self.addGestureRecognizer(to: viewController.view)
  }

  private func addGestureRecognizer(to view: UIView) {
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
//    gesture.delegate = self
    gesture.edges = .left
    view.addGestureRecognizer(gesture)
  }

  @objc
  func handleGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
    guard let view = gesture.view else { return }
    let progress = gesture.translation(in: view).x / navigationController.view.frame.width

    guard progress > 0 else { return }

    print("testing___", progress)

    switch gesture.state {
    case .began:
      isTransitioning = true
      navigationController.popViewController(animated: true)
    case .changed:
      update(progress)
    case .cancelled, .ended:
      if progress > 0.5 {
        finish()
      } else {
        cancel()
      }
      isTransitioning = false
    default: break
    }
  }
}

//extension ZoomingInteractiveTransition: UIGestureRecognizerDelegate {
//  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//    isTransitioning = true
//    navigationController.popViewController(animated: true)
//    return true
//  }
//
//  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    otherGestureRecognizer === navigationController.interactivePopGestureRecognizer
//  }
//}
