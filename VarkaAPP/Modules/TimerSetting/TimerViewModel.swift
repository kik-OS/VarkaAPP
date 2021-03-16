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
    var seconds: Int { get }
    var isEnabledStartButton: Bool { get }
    
    init(minutes: Int)
    
    func updateTimeTo(minutes: Int, seconds: Int)
}

final class TimerViewModel: TimerViewModelProtocol {
    
    // MARK: - Properties
    
    var minutes: Int {
        time / 60
    }
    
    var seconds: Int {
        time - (minutes * 60)
    }
    
    var isEnabledStartButton: Bool {
        time != 0
    }
    
    private var time: Int {
        didSet {
            print("Timer is \(minutes) min \(seconds) sec")
        }
    }
    
    // MARK: - Initializers
    
    init(minutes: Int = 0) {
        time = minutes * 60
    }
    
    // MARK: - Public methods
    
    func updateTimeTo(minutes: Int, seconds: Int) {
        time = (minutes * 60) + seconds
    }
}
