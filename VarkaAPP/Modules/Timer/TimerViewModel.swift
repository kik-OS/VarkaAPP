//
//  TimerViewModel.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 16.03.2021.
//

import Foundation

// MARK: - Protocols

protocol TimerViewModelProtocol {
    var minutes: Int { get }
    var isEnabledStartButton: Bool { get }
    
    init(minutes: Int)
    
    func updateTimeTo(minutes: Int)
}

final class TimerViewModel: TimerViewModelProtocol {
    
    // MARK: - Properties
    
    var minutes: Int = 0 {
        didSet {
            print("Timer is \(minutes) min")
        }
    }
    
    var isEnabledStartButton: Bool {
        minutes != 0
    }
    
    // MARK: - Initializers
    
    init(minutes: Int = 0) {
        self.minutes = minutes
    }
    
    // MARK: - Public methods
    
    func updateTimeTo(minutes: Int) {
        self.minutes = minutes
    }
}
