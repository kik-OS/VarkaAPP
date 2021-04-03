//
//  TimerManager.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 29.03.2021.
//

import Foundation

protocol TimerManagerBarDelegate: class {
    func timerDidStep(time: String)
}

protocol TimerManagerTimerViewDelegate: class {
    func timerDidStep(totalSeconds: Int, remainingSeconds: Int, isStopped: Bool)
}

protocol TimerManagerProtocol {
    var isActive: Bool { get }
    var barDelegate: TimerManagerBarDelegate? { get set }
    var timerViewDelegate: TimerManagerTimerViewDelegate? { get set }
    
    func start(forMinutes minutes: Int)
    func stop()
    func getTimerTime() -> (totalSeconds: Int, remainingSeconds: Int)
}

final class TimerManager: TimerManagerProtocol {
    
    // MARK: - Static properties
    
    static let shared = TimerManager()
    
    // MARK: - Properties
    
    var isActive = false
    weak var barDelegate: TimerManagerBarDelegate?
    weak var timerViewDelegate: TimerManagerTimerViewDelegate?
    
    private var stringTimerTime: String {
        let minutes = timerTime / 60
        let seconds = timerTime - (minutes * 60)
        let stringSeconds = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        
        return timerTime > 0
            ? "\(minutes):\(stringSeconds)"
            : "Готово!"
    }
    
    /// Общее время таймера в секундах.
    private var totalTime = 0
    
    /// Текущее время таймера в секундах.
    private var timerTime = 0
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public methods
    
    func start(forMinutes minutes: Int) {
        totalTime = minutes * 60
        timerTime = totalTime
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer),
                             userInfo: nil, repeats: true)
        isActive = true
    }
    
    @objc private func updateTimer(sender: Timer) {
        guard isActive, timerTime >= 0 else {
            isActive = false
            sender.invalidate()
            
            return
        }
        barDelegate?.timerDidStep(time: stringTimerTime)
        timerViewDelegate?.timerDidStep(totalSeconds: totalTime, remainingSeconds: timerTime, isStopped: false)
        timerTime -= 1
    }
    
    func stop() {
        isActive = false
        barDelegate?.timerDidStep(time: "")
        timerViewDelegate?.timerDidStep(totalSeconds: totalTime, remainingSeconds: timerTime, isStopped: true)
    }
    
    func getTimerTime() -> (totalSeconds: Int, remainingSeconds: Int) {
        (totalTime, timerTime)
    }
}
