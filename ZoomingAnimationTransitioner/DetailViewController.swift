//
//  DetailViewController.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit

final class DetailViewController: UIViewController, ZoomingAnimationDestinatable {
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
  }
}
