//
//  CharactersCollectionViewModelTests.swift
//  BreakingBadTests
//
//  Created by Joshua Simmons on 01/12/2020.
//

import XCTest
@testable import BreakingBad

// Improve: Abstract away pattern of running test, mapping states and checking output
class CharactersCollectionViewModelTests: XCTestCase {

    private struct Components {
        let viewModel: CharactersCollectionViewModel
        let view: SpyCharacterCollectionView
        let navigator: SpyCharactersNavigation
        let webService: SpyCharactersWebService
    }

    // MARK: - Tests

    func testViewDidLoad() throws {
        let components = makeComponents()

        components.viewModel.viewDidLoad()

        XCTAssertEqualWithDiff(components.view.invokedUpdateParametersList.map(\.state), [.loading])
    }

    func testLoadCharacters() {
        let components = makeComponents()
        let characters = [Character.makeStub()]

        components.webService.stubbedGetCharactersHandlerResult = (
            Result<[Character], RequestError>.success(characters),
            ()
        )
        components.viewModel.viewDidLoad()

        XCTAssertEqualWithDiff(
            components.view.invokedUpdateParametersList.map(\.state),
            [
                .loading,
                .showing(.init(displayingAll: characters))
            ]
        )
    }

    func testFailureToLoadCharacters() {
        let components = makeComponents()

        components.webService.stubbedGetCharactersHandlerResult = (
            Result<[Character], RequestError>.failure(.http),
            ()
        )
        components.viewModel.viewDidLoad()

        XCTAssertEqualWithDiff(
            components.view.invokedUpdateParametersList.map(\.state),
            [
                .loading,
                .error
            ]
        )
    }

    func testRetryAfterFailure() {
        let components = makeComponents()
        let characters = [Character.makeStub()]

        components.webService.stubbedGetCharactersHandlerResult = (
            Result<[Character], RequestError>.failure(.http),
            ()
        )
        components.viewModel.viewDidLoad()
        components.webService.stubbedGetCharactersHandlerResult = (
            Result<[Character], RequestError>.success(characters),
            ()
        )
        components.viewModel.didTapRetry()

        XCTAssertEqualWithDiff(
            components.view.invokedUpdateParametersList.map(\.state),
            [
                .loading,
                .error,
                .loading,
                .showing(.init(displayingAll: characters))
            ]
        )
    }

    func testSearching() {
        let components = makeComponents()
        let walter = Character.makeStub(name: "Walter White")
        let walterJr = Character.makeStub(name: "Walter White Jr.")
        let jesse = Character.makeStub(name: "Jesse Pinkman")
        let skyler = Character.makeStub(name: "Skyler White")
        let characters = [walter, walterJr, jesse, skyler]

        components.webService.stubbedGetCharactersHandlerResult = (
            Result<[Character], RequestError>.success(characters),
            ()
        )
        components.viewModel.viewDidLoad()
        components.viewModel.didUpdate(searchTerm: "Walt")
        components.viewModel.didUpdate(searchTerm: "jeS")
        components.viewModel.didUpdate(searchTerm: "hite")
        components.viewModel.didUpdate(searchTerm: "")
        components.viewModel.didUpdate(searchTerm: nil)

        XCTAssertEqualWithDiff(
            components.view.invokedUpdateParametersList.map(\.state),
            [
                .loading,
                .showing(.init(displayingAll: characters)),
                .showing(.init(displayed: [walter, walterJr], all: characters)),
                .showing(.init(displayed: [jesse], all: characters)),
                .showing(.init(displayed: [walter, walterJr, skyler], all: characters)),
                .showing(.init(displayingAll: characters)),
            ]
        )
    }

    // MARK: - Helpers

    private func makeComponents() -> Components {
        let navigator = SpyCharactersNavigation()
        let webService = SpyCharactersWebService()
        let viewModel = CharactersCollectionViewModel(
            dispatchQueue: TestAsyncDispatchQueue(),
            navigator: navigator,
            webService: webService
        )
        let view = SpyCharacterCollectionView()
        viewModel.setView(view)
        return Components(viewModel: viewModel, view: view, navigator: navigator, webService: webService)
    }
}
