//
//  TimerManager.swift
//  VarkaAPP
//
//  Created by Evgeny Novgorodov on 29.03.2021.
//

import Foundation
import UIKit
import BackgroundTasks

protocol TimerManagerBarDelegate: class {
    func timerDidStep(remainingSeconds: Int, isStopped: Bool)
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
    
    private init() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.Kik-OS.VarkaAPP.timer",
                                        using: .global(qos: .userInteractive)) { bgTask in
            self.handleBackgroundTask(bgTask as! BGProcessingTask)
        }
    }
    
    // MARK: - Public methods
    
    func start(forMinutes minutes: Int) {
        totalTime = minutes * 60
        timerTime = totalTime
        let newTimer = Timer.scheduledTimer(timeInterval: 1,
                                            target: self,
                                            selector: #selector(updateTimer),
                                            userInfo: nil,
                                            repeats: true)
        RunLoop.current.add(newTimer, forMode: .common)
        timer = newTimer
        isActive = true
    }
    
    func stop() {
        isActive = false
        barDelegate?.timerDidStep(remainingSeconds: timerTime, isStopped: true)
        timerViewDelegate?.timerDidStep(totalSeconds: totalTime,
                                        remainingSeconds: timerTime,
                                        isStopped: true)
    }
    
    func getTimerTime() -> (totalSeconds: Int, remainingSeconds: Int) {
        (totalTime, timerTime)
    }
    
    func saveTime() {
        if isActive {
            scheduleBackgroundTask()
        }
        savedTime = isActive
            ? (timerTime: timerTime, time: CFAbsoluteTimeGetCurrent())
            : nil
    }
    
    func readSavedTime() {
        guard let savedTime = savedTime else { return }
        
        let elapsedTimeByTimer = savedTime.timerTime - timerTime
        let elapsedTimeAccurately = CFAbsoluteTimeGetCurrent() - savedTime.time
        print("По таймеру прошло \(elapsedTimeByTimer) секунд")
        print("Точно прошло \(String(format: "%.5f", elapsedTimeAccurately)) секунд")
        
        let delta = Int(elapsedTimeAccurately.rounded()) - elapsedTimeByTimer
        if delta > 1 {
            print("Подвожу таймер на \(delta) секунд")
            timerTime = timerTime - delta
        }
    }
    
    // MARK: - Private methods
    
    @objc private func updateTimer(sender: Timer) {
        var backgroundTask = UIApplication.shared.beginBackgroundTask()
        
        guard isActive, timerTime >= 0 else {
            isActive = false
            sender.invalidate()
            backgroundTask = UIBackgroundTaskIdentifier.invalid
            return
        }
        
        barDelegate?.timerDidStep(remainingSeconds: timerTime, isStopped: false)
        timerViewDelegate?.timerDidStep(totalSeconds: totalTime,
                                        remainingSeconds: timerTime,
                                        isStopped: false)
        timerTime -= 1
        
        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
            if UIApplication.shared.applicationState == .active {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    private func handleBackgroundTask(_ task: BGProcessingTask) {
        task.expirationHandler = {
            print("bgTask has expired!")
            task.setTaskCompleted(success: true)
        }
        print("bgTask did start")
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print(self.timerTime, "!!!!!!!!!")
        }
        
        scheduleBackgroundTask()
    }
    
    private func scheduleBackgroundTask() {
        let countdownTask = BGProcessingTaskRequest(identifier: "com.Kik-OS.VarkaAPP.timer")
        countdownTask.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        countdownTask.requiresExternalPower = false
        countdownTask.requiresNetworkConnectivity = false
        
        do {
            try BGTaskScheduler.shared.submit(countdownTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}
