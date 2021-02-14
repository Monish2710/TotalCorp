//
//  CollectionViewCell.swift
//  CustomTransitionDemo
//
//  Created by Tung on 13.10.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet private(set) var locationImageView: UIImageView!
    @IBOutlet private(set) var locationLabel: UILabel!

    private lazy var setupOnce: Void = {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        locationImageView.layer.cornerRadius = 15
        downloadButton.layer.cornerRadius = 25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }()


    override func layoutSubviews() {
        super.layoutSubviews()

        _ = setupOnce
    }

    func configure(with cellData: CellData) {
        locationImageView.image = cellData.image
        locationLabel.text = cellData.title
    }
}

struct CellData {

    let image: UIImage
    let title: String
}
