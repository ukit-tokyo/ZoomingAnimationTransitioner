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

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      systemItem: .close,
      primaryAction: UIAction { [weak self] _ in
        self?.dismiss(animated: true)
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
