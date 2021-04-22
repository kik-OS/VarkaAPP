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
    var timerTime: (totalSeconds: Int, remainingSeconds: Int) { get }
    var isHiddenPickerStackView: Bool { get }
    var isHiddenDiagramStackView: Bool { get }
    var isEnabledStartButton: Bool { get }
    var isHiddenStartButton: Bool { get }
    var isHiddenStopButton: Bool { get }
    var setupPickerView: (() -> Void)? { get set }
    /// Вызывается при каждом шаге таймера.
    var timerDidStep: ((_ totalSeconds: Int, _ remainingSeconds: Int) -> Void)? { get set }
    /// Вызывается при остановке таймера пользователем.
    var timerDidStop: (() -> Void)? { get set }
    /// Вызывается при истечении времени таймера.
    var timerDidExpired: (() -> Void)? { get set }
    
    init(minutes: Int)
    
    func updateTimeTo(minutes: Int)
    func startTimer()
    func stopTimer()
}

final class TimerViewModel: TimerViewModelProtocol {
    
    // MARK: - Properties
    
    var minutes: Int
    
    var timerTime: (totalSeconds: Int, remainingSeconds: Int) {
        timerManager.getTimerTime()
    }
    
    var isHiddenPickerStackView: Bool {
        timerManager.isActive
    }
    
    var isHiddenDiagramStackView: Bool {
        !timerManager.isActive
    }
    
    var isEnabledStartButton: Bool {
        !timerManager.isActive && minutes != 0
    }
    
    var isHiddenStartButton: Bool {
        timerManager.isActive
    }
    
    var isHiddenStopButton: Bool {
        !timerManager.isActive
    }
    
    var setupPickerView: (() -> Void)?
    var timerDidStep: ((_ totalSeconds: Int, _ remainingSeconds: Int) -> Void)?
    var timerDidStop: (() -> Void)?
    var timerDidExpired: (() -> Void)?
    
    private var timerManager: TimerManagerProtocol = TimerManager.shared
        
    // MARK: - Initializers
    
    init(minutes: Int = 0) {
        self.minutes = minutes
        timerManager.timerViewDelegate = self
    }
    
    // MARK: - Public methods
    
    func updateTimeTo(minutes: Int) {
        self.minutes = minutes
    }
    
    func startTimer() {
        timerManager.start(forMinutes: minutes)
    }
    
    func stopTimer() {
        timerManager.stop()
    }
}

extension TimerViewModel: TimerManagerTimerViewDelegate {
    
    func timerDidStep(totalSeconds: Int, remainingSeconds: Int, isStopped: Bool) {
        isStopped
            ? timerDidStop?()
            : timerDidStep?(totalSeconds, remainingSeconds)
    }
    
    func timerHasExpired() {
        timerDidExpired?()
    }
}
