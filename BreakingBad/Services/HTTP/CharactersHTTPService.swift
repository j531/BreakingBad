//
//  CharactersHTTPService.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 20/11/2020.
//

import Foundation

protocol CharactersWebService {
    func getCharacters(then handler: @escaping (Result<[Character], RequestError>) -> Void)
}

final class CharactersHTTPService: CharactersWebService {

    // MARK: - Static properties

    private static let baseURL = "https://www.breakingbadapi.com/api/"

    // MARK: - Requests

    func getCharacters(then handler: @escaping (Result<[Character], RequestError>) -> Void) {
        let url = makeURL(withPath: "characters")

        //  Improve: Abstract all this away...
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                handler(.failure(.http))
                return
            }
            guard
                let data = data,
                let characters = try? JSONDecoder().decode([Character].self, from: data)
            else {
                handler(.failure(.decoding))
                return
            }
            handler(.success(characters))
        }
        task.resume()
    }

    // MARK: - Helpers

    private func makeURL(withPath path: String) -> URL {
        guard let url = URL(string: Self.baseURL) else { fatalError("Cannot build baseURL") }
        return url.appendingPathComponent(path)
    }
}
