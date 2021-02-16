//
//  CharactersCollectionViewModel.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 20/11/2020.
//

import Foundation

final class CharactersCollectionViewModel {

    enum State: Equatable {
        case loading
        case showing(CharactersState)
        case error
        
        struct CharactersState: Equatable {
            let displayed: [Character]
            fileprivate let all: [Character]

            init(displayingAll characters: [Character]) {
                displayed = characters
                all = characters
            }

            init(displayed: [Character], all: [Character]) {
                self.displayed = displayed
                self.all = all
            }
        }
    }

    // MARK: - Private properties

    private let stateCoordinator: StateCoordinator<State>
    private let navigator: CharactersNavigation
    private let webService: CharactersWebService

    // MARK: - Init

    init(
        dispatchQueue: AsyncDispatchQueue = DispatchQueue.main,
        navigator: CharactersNavigation,
        webService: CharactersWebService
    ) {
        self.navigator = navigator
        self.webService = webService
        stateCoordinator = StateCoordinator(initialState: .loading, dispatchQueue: dispatchQueue)
    }

    // MARK: - Wiring

    func setView<View: StateUpdatable>(_ view: View) where View.State == State {
        stateCoordinator.setView(view)
    }

    // MARK: - Input

    func viewDidLoad() {
        requestCharacters()
    }

    func didTapRetry() {
        requestCharacters()
    }

    func didSelectItem(atIndex index: Int) {
        guard
            case let .showing(charactersState) = stateCoordinator.state,
            let character = charactersState.displayed[safe: index]
        else { return }

        navigator.pushDetails(for: character)
    }

    func didUpdate(searchTerm: String?) {
        guard case let .showing(charactersState) = stateCoordinator.state else { return }

        let allCharacters = charactersState.all

        guard
            let cleanSearchTerm = searchTerm?.trimmingCharacters(in: .whitespacesAndNewlines),
            !cleanSearchTerm.isEmpty
        else {
            stateCoordinator.state = .showing(.init(displayingAll: allCharacters))
            return
        }

        let filteredCharacters = allCharacters.filtered(bySearchTerm: cleanSearchTerm)
        stateCoordinator.state = .showing(.init(displayed: filteredCharacters, all: allCharacters))
    }

    // MARK: - Operations

    private func requestCharacters() {
        stateCoordinator.state = .loading

        webService.getCharacters { [weak self] result in
            switch result {
            case .failure:
                self?.stateCoordinator.state = .error
            case let .success(characters):
                self?.stateCoordinator.state = .showing(.init(displayingAll: characters))
            }
        }
    }
}

private extension Collection where Element == Character {
    func filtered(bySearchTerm searchTerm: String) -> [Character] {
        filter { (element) -> Bool in
            element.name.lowercased().contains(searchTerm.lowercased())
        }
    }
}
