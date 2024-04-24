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
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  lazy var titleLabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .boldSystemFont(ofSize: 20)
    return label
  }()

  lazy var bodyLabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()

  private let interactionController = UIPercentDrivenInteractiveTransition()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Detail"

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      systemItem: .close,
      primaryAction: UIAction { [weak self] _ in
        if self?.presentingViewController == nil {
          self?.navigationController?.popViewController(animated: true)
        } else {
          self?.dismiss(animated: true)
        }
      })

    view.backgroundColor = .systemBackground
    view.addSubview(imageView)
    view.addSubview(titleLabel)
    view.addSubview(bodyLabel)

    imageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(imageView.snp.width)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(16)
      make.left.right.equalToSuperview().inset(16)
    }
    bodyLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.left.right.equalToSuperview().inset(16)
    }

    imageView.image = UIImage(named: "new-york-city")
    titleLabel.text = "Title"
    bodyLabel.text = """
    Once upon a time in a small, bustling village by the sea, there lived a young boy named Tommy. Tommy was known throughout the village for his curious nature and his bright, twinkling eyes which seemed always in search of new adventures.

    One sunny morning, Tommy set out from his little wooden house with a mission in mind. He had heard tales from the old fishermen about a mysterious island that appeared only when the sun and moon aligned in a particular way. Today was that rare day, and Tommy was determined to find it.
    """
  }
}
