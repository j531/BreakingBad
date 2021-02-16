//
//  CharacterCollectionViewCell.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 19/11/2020.
//

import Foundation
import UIKit
import Nuke

final class CharacterCollectionViewCell: UICollectionViewCell {

    struct Config {
        let name: String
        let imageURL: String
    }

    // MARK: - Private properties

    private var imageLoadTask: ImageTask?

    private let imageView = UIImageView().then { view in
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .systemFill
    }
    
    private let nameLabel = UILabel().then { label in
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadTask?.cancel()
        imageView.image = nil
    }

    // MARK: - Setup

    func setup(with config: Config) {
        nameLabel.text = config.name

        if let imageURL = URL(string: config.imageURL) {
            imageLoadTask = Nuke.loadImage(with: imageURL, into: imageView)
        }
    }

    private func setup() {
        backgroundColor = .secondarySystemBackground
        clipsToBounds = true
        layer.cornerRadius = 18

        let nameContainer = UIView()

        addSubview(imageView)
        addSubview(nameContainer)
        nameContainer.addSubview(nameLabel)

        imageView.edgesToSuperview(excluding: .bottom)
        imageView.bottomToTop(of: nameContainer)
        nameContainer.edgesToSuperview(excluding: .top)
        nameContainer.height(50)
        nameLabel.centerInSuperview()
        nameLabel.leftToSuperview(offset: 14)
        nameLabel.topToSuperview()
    }
}
