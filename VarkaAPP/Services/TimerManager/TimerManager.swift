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
    func handleBackgroundTask(_ task: BGProcessingTask)
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
    /// Время бэкграунд таймера в секундах.
    private var bgTimerTime = 0 // TEMP
    
    // MARK: - Initializers
    
    private init() {}
    
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
    
    func handleBackgroundTask(_ task: BGProcessingTask) {
        task.expirationHandler = {
            print("Background task has expired!")
            task.setTaskCompleted(success: false)
        }
        
        print("Background task did start")
        bgTimerTime = timerTime
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard self.isActive, self.bgTimerTime >= 0 else {
                self.isActive = false
                timer.invalidate()
                task.setTaskCompleted(success: true)
                return
            }
            
            print("Background timer:", self.bgTimerTime)
            self.bgTimerTime -= 1
        }
        
//        scheduleBackgroundTask()
    }
    
    private func scheduleBackgroundTask() {
        let bgTaskRequest = BGProcessingTaskRequest(identifier: "com.Kik-OS.VarkaAPP.timer")
        bgTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 1)
        bgTaskRequest.requiresExternalPower = false
        bgTaskRequest.requiresNetworkConnectivity = false
        
        do {
            try BGTaskScheduler.shared.submit(bgTaskRequest)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
}
