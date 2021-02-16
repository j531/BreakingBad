//
//  AsyncDispatchQueue.swift
//  BreakingBad
//
//  Created by Joshua Simmons on 10/12/2020.
//

import Foundation

protocol AsyncDispatchQueue {
    func async(execute work: @escaping @convention(block) () -> Void)
}
