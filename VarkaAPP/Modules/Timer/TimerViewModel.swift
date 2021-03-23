//
//  TimerViewModel.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 16.03.2021.
//

import Foundation

// MARK: - Protocols

protocol TimerViewModelDelegate: class {
    func startTimerOn(minutes: Int)
}

protocol TimerViewModelProtocol {
    var minutes: Int { get }
    var isEnabledStartButton: Bool { get }
    
    init(minutes: Int, delegate: TimerViewModelDelegate)
    
    func updateTimeTo(minutes: Int)
    func startTimer()
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
    
    private weak var delegate: TimerViewModelDelegate?
    
    // MARK: - Initializers
    
    init(minutes: Int = 0, delegate: TimerViewModelDelegate) {
        self.minutes = minutes
        self.delegate = delegate
    }
    
    // MARK: - Public methods
    
    func updateTimeTo(minutes: Int) {
        self.minutes = minutes
    }
    
    func startTimer() {
        delegate?.startTimerOn(minutes: minutes)
    }
}
