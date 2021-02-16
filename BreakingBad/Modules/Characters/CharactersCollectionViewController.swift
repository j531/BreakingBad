//
//  CharactersCollectionViewController.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 19/11/2020.
//

import Foundation
import UIKit

final class CharactersCollectionViewController: UIViewController, StateUpdatable {

    private typealias DataSource = UICollectionViewDiffableDataSource<DataSourceSection, Character>

    private enum DataSourceSection {
        case main
    }

    // MARK: - Private properties

    private let collectionView: UICollectionView
    private let viewModel: CharactersCollectionViewModel
    private let errorView = UIView()

    private let searchController = UISearchController().then { view in
        view.obscuresBackgroundDuringPresentation = false
        view.searchBar.autocorrectionType = .no
        view.searchBar.autocapitalizationType = .none
    }

    private let loadingIndicator = UIActivityIndicatorView(style: .large).then { view in
        view.hidesWhenStopped = true
    }

    private let errorLabel = UILabel().then { label in
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .center

        let errorText = NSMutableAttributedString(
            string: "Error",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)
            ]
        )
        errorText.append(
            .init(
                string: "\nPlease try again later",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout)
                ]
            )
        )
        label.attributedText = errorText
    }

    private let noResultsLabel = UILabel().then { label in
        label.text = "No results"
        label.textColor = UIColor.secondaryLabel
    }

    private lazy var retryButton = UIButton(type: .system).then { button in
        button.setTitle("Retry", for: .normal)
        button.addAction(
            UIAction { [viewModel] _ in viewModel.didTapRetry() },
            for: .touchUpInside
        )
    }

    private lazy var dataSource: DataSource = {
        let cellRegistration = UICollectionView.CellRegistration<CharacterCollectionViewCell, Character> {
            cell, indexPath, character in

            let cellConfig = CharacterCollectionViewCell.Config(
                name: character.name,
                imageURL: character.imageURL
            )
            cell.setup(with: cellConfig)
        }
        let dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, character) -> UICollectionViewCell? in

            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: character
            )
        }
        return dataSource
    }()

    // MARK: - Init

    init(viewModel: CharactersCollectionViewModel) {
        self.viewModel = viewModel
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Characters"
        navigationItem.hidesSearchBarWhenScrolling = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        searchController.searchResultsUpdater = self

        setupViews()

        viewModel.viewDidLoad()
    }

    // MARK: - Update

    func update(with state: CharactersCollectionViewModel.State) {
        DispatchQueue.main.async {
            self.setup(for: state)
        }
    }

    // MARK: - Setup

    private func setup(for state: CharactersCollectionViewModel.State) {
        switch state {
        case .error:
            setupForError()
        case .loading:
            setupForLoading()
        case let .showing(characters):
            setup(showing: characters.displayed)
        }
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
        view.addSubview(noResultsLabel)
        errorView.addSubview(errorLabel)
        errorView.addSubview(retryButton)

        loadingIndicator.isHidden = true
        errorView.isHidden = true

        loadingIndicator.centerInSuperview()
        noResultsLabel.top(to: view.safeAreaLayoutGuide, offset: 40)
        noResultsLabel.centerXToSuperview()
        errorView.centerInSuperview()
        errorLabel.edgesToSuperview(excluding: .bottom)
        errorLabel.bottomToTop(of: retryButton, offset: -4)
        retryButton.edgesToSuperview(excluding: .top)
        collectionView.edgesToSuperview()
    }

    private func setupForLoading() {
        loadingIndicator.startAnimating()
        dataSource.apply(.allItemsRemoved)
        errorView.isHidden = true
        noResultsLabel.isHidden = true
        navigationItem.searchController = nil
    }

    private func setupForError() {
        loadingIndicator.stopAnimating()
        dataSource.apply(.allItemsRemoved)
        errorView.isHidden = false
        noResultsLabel.isHidden = true
        navigationItem.searchController = nil
    }

    private func setup(showing characters: [Character]) {
        loadingIndicator.stopAnimating()
        errorView.isHidden = true
        navigationItem.searchController = searchController

        var snapshot = NSDiffableDataSourceSnapshot<DataSourceSection, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        dataSource.apply(snapshot)

        noResultsLabel.isHidden = !characters.isEmpty
    }

    // MARK: - Layout

    private static func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let margin: CGFloat = 14

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(margin)
        group.contentInsets = .init(top: 0, leading: margin, bottom: 0, trailing: margin)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = margin
        section.contentInsets = .init(top: margin, leading: 0, bottom: margin, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension CharactersCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(atIndex: indexPath.row)
    }
}

extension CharactersCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.didUpdate(searchTerm: searchController.searchBar.text)
    }
}
