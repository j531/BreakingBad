//
//  StateCoordinator.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 10/12/2020.
//

import Foundation

protocol StateUpdatable: class {
    associatedtype State
    func update(with state: State)
}

/// Keeps track of state and updates view on the dispatch queue (normally main thread) when the state is updated.
final class StateCoordinator<State: Equatable> {

    // MARK: - Public properties

    var state: State {
        didSet {
            guard state != oldValue else { return }
            updateView()
        }
    }

    // MARK: - Private properties

    private var view: WeakReferencingAnyStateUpdatable<State>?
    private let dispatchQueue: AsyncDispatchQueue

    // MARK: - Init

    init(initialState: State, dispatchQueue: AsyncDispatchQueue = DispatchQueue.main) {
        state = initialState
        self.dispatchQueue = dispatchQueue
    }

    // MARK: - Wiring

    func setView<View: StateUpdatable>(_ view: View) where View.State == State {
        self.view = WeakReferencingAnyStateUpdatable(stateUpdatable: view)
        updateView()
    }

    // MARK: - Updating

    private func updateView() {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }
            self.view?.update(with: self.state)
        }
    }
}

/// Type erased StateUpdatable that weakly references the contained entity.
private class WeakReferencingAnyStateUpdatable<State>: StateUpdatable {

    // MARK: - Private properties

    private let updateWithState: (State) -> Void

    // MARK: - Init

    init<S: StateUpdatable>(stateUpdatable: S) where S.State == State {
        updateWithState = { [weak stateUpdatable] state in
            stateUpdatable?.update(with: state)
        }
    }

    // MARK: - Methods

    func update(with state: State) {
        updateWithState(state)
    }
}
