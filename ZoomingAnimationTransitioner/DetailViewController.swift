//
//  DetailViewController.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit

final class DetailViewController: UIViewController {
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let interactionController = UIPercentDrivenInteractiveTransition()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      systemItem: .close,
      primaryAction: UIAction { [weak self] _ in
        if self?.presentingViewController == nil {
          self?.navigationController?.popViewController(animated: true)
        } else {
          self?.dismiss(animated: true)
        }
      })

    view.backgroundColor = .orange
    view.addSubview(imageView)

    imageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(imageView.snp.width)
    }

    let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(_:)))
    view.addGestureRecognizer(recognizer)
  }

  @objc func handle(_ gesture: UIPanGestureRecognizer) {
    let progress = gesture.translation(in: view).x / view.bounds.size.width
    guard progress > 0 else { return }

    print("testing___", progress)

    switch gesture.state {
    case .possible: break
    case .began: break
    case .changed:
      interactionController.update(progress)
    case .cancelled, .ended:
      if progress > 0.5 {
        interactionController.finish()
      } else {
        interactionController.cancel()
      }
    case .failed: break
    @unknown default: break
    }
  }
}
