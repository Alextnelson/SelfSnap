//
//  PhotoCollectionViewCell.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/27/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "\(PhotoCollectionViewCell.self)"

    let imageView = UIImageView()

    override func layoutSubviews() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }
}
