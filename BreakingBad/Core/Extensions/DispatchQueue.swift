//
//  DispatchQueue.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 10/12/2020.
//

import Foundation

extension DispatchQueue: AsyncDispatchQueue {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
