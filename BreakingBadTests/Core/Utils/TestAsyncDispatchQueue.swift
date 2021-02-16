//
//  TestAsyncDispatchQueue.swift
//  BreakingBadTests
//
//  Created by Joshua Simmons on 10/12/2020.
//

import Foundation
@testable import BreakingBad

/// Executes work immediately.
class TestAsyncDispatchQueue: AsyncDispatchQueue {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
