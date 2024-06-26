//
//  ViewController.swift
//  ZoomingAnimationTransitioner
//
//  Created by Taichi Yuki on 2024/04/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  lazy var collectionView: UICollectionView = {
    let margin: CGFloat = 16
    let width = floor((UIScreen.main.bounds.width - margin * 3) / 2)
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: width, height: width + 60)
    layout.minimumLineSpacing = margin
    layout.minimumInteritemSpacing = margin
    layout.sectionInset = .init(top: margin, left: margin, bottom: margin, right: margin)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  private var transitioner: ZoomingAnimationTransitioner?

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Collection"

    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")

    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.bottom.equalToSuperview()
    }
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
    cell.set(thumb: UIImage(named: "new-york-city"), title: "title", subtitle: "subtitle")
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let thumbnailView = (collectionView.cellForItem(at: indexPath) as! CardCell).thumbnailView
//    let vc = DetailViewController()
//    self.transitioner = ZoomingAnimationTransitioner(from: thumbnailView, to: vc.imageView)
//    let nc = UINavigationController(rootViewController: vc)
//    nc.transitioningDelegate = transitioner
//    nc.modalPresentationStyle = .fullScreen
//    present(nc, animated: true)

    let vc = DetailViewController()
    let zoomingNavigationController = navigationController as? ZoomingAnimationNavigationController
    zoomingNavigationController?.set(from: thumbnailView, to: vc.imageView)
    zoomingNavigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: -

final class CardCell: UICollectionViewCell {
  lazy var thumbnailView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 4
    imageView.layer.masksToBounds = true
    return imageView
  }()
  lazy var titleLabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .boldSystemFont(ofSize: 16)
    return label
  }()
  lazy var subtitleLabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 16)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let stackView = UIStackView(arrangedSubviews: [thumbnailView, titleLabel, subtitleLabel])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = 2

    contentView.addSubview(stackView)
    thumbnailView.snp.makeConstraints { make in
      make.height.equalTo(thumbnailView.snp.width)
    }
    stackView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(thumb: UIImage?, title: String, subtitle: String) {
    thumbnailView.image = thumb
    titleLabel.text = title
    subtitleLabel.text = subtitle
  }
}


