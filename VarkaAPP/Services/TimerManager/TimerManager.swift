//
//  TimerManager.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 29.03.2021.
//

import UIKit

protocol TimerManagerBarDelegate: class {
    func timerDidStep(remainingSeconds: Int, isStopped: Bool)
}

protocol TimerManagerTimerViewDelegate: class {
    func timerDidStep(totalSeconds: Int, remainingSeconds: Int, isStopped: Bool)
    func timerHasExpired()
}

protocol TimerManagerProtocol {
    var isActive: Bool { get }
    var barDelegate: TimerManagerBarDelegate? { get set }
    var timerViewDelegate: TimerManagerTimerViewDelegate? { get set }
    
    func start(forMinutes minutes: Int)
    func stop()
    func getTimerTime() -> (totalSeconds: Int, remainingSeconds: Int)
    func saveTime()
    func readSavedTime()
}

final class TimerManager: TimerManagerProtocol {
    
    // MARK: - Static properties
    
    static let shared = TimerManager()
    
    // MARK: - Properties
    
    var isActive = false
    weak var barDelegate: TimerManagerBarDelegate?
    weak var timerViewDelegate: TimerManagerTimerViewDelegate?
    
    private var savedTime: (timerTime: Int, time: Double)?
    private var timer = Timer()
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
        let newTimer = Timer.scheduledTimer(timeInterval: 1,
                                            target: self,
                                            selector: #selector(stepTimer),
                                            userInfo: nil,
                                            repeats: true)
        RunLoop.current.add(newTimer, forMode: .common)
        timer = newTimer
        isActive = true
    }
    
    func stop() {
        isActive = false
        updateTimers(remainingTime: timerTime, isStopped: true)
    }
    
    func getTimerTime() -> (totalSeconds: Int, remainingSeconds: Int) {
        (totalTime, timerTime)
    }
    
    func saveTime() {
        savedTime = isActive
            ? (timerTime: timerTime, time: CFAbsoluteTimeGetCurrent())
            : nil
    }
    
    func readSavedTime() {
        guard let savedTime = savedTime else { return }
        
        let elapsedTimeByTimer = savedTime.timerTime - timerTime
        let elapsedTimeAccurately = CFAbsoluteTimeGetCurrent() - savedTime.time
        
        let isOverTime = elapsedTimeAccurately > Double(savedTime.timerTime) && isActive
        if isOverTime {
            isActive = false
            updateTimers(remainingTime: 0, isStopped: false)
            timerViewDelegate?.timerHasExpired()
        } else if isActive {
            let delta = Int(elapsedTimeAccurately.rounded()) - elapsedTimeByTimer
            if delta > 1 {
                timerTime = timerTime - delta
            }
        }
    }
    
    // MARK: - Private methods
    
    @objc private func stepTimer(sender: Timer) {
        var backgroundTask = UIApplication.shared.beginBackgroundTask()
        
        guard isActive, timerTime >= 0 else {
            isActive = false
            sender.invalidate()
            backgroundTask = UIBackgroundTaskIdentifier.invalid
            return
        }
        
        updateTimers(remainingTime: timerTime, isStopped: false)
        if timerTime == 0 {
            timerViewDelegate?.timerHasExpired()
        }
        timerTime -= 1
        
        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
            if UIApplication.shared.applicationState == .active {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    private func updateTimers(remainingTime: Int, isStopped: Bool) {
        barDelegate?.timerDidStep(remainingSeconds: remainingTime, isStopped: isStopped)
        timerViewDelegate?.timerDidStep(totalSeconds: totalTime, remainingSeconds: remainingTime, isStopped: isStopped)
    }
}
