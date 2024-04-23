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

  private let backSwipeGesture: SwipeGestureRecognizer = {
    let gesture = SwipeGestureRecognizer()
    gesture.direction = .right
    return gesture
  }()
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
    case .push: transitioner.transitionType = .show
    case .pop: transitioner.transitionType = .back
    default: return nil
    }
    return transitioner
  }

  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    guard viewController is ZoomingAnimationDestinatable else {
      navigationController.view.removeGestureRecognizer(backSwipeGesture)
      return
    }

    backSwipeGesture.navigationController = navigationController
    backSwipeGesture.addTarget(self, action: #selector(handleSwipe(_:)))
    navigationController.view.addGestureRecognizer(backSwipeGesture)
  }

  @objc func handleSwipe(_ sender: SwipeGestureRecognizer) {
    sender.navigationController?.popViewController(animated: true)
  }
}

final class SwipeGestureRecognizer: UISwipeGestureRecognizer {
  weak var navigationController: UINavigationController?
}
