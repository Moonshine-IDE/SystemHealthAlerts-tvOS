//
//  ReloadTimer.swift
//  SystemHealthAlerts
//
//  Created by Devsena on 04/09/20.
//  Copyright © 2020 Devsena. All rights reserved.
//

import Foundation

protocol ReloadTimerDelegates: AnyObject
{
    func reloadTimerCountdown(value:String)
    func lastUpdatedOn(datetime:String)
    func onTimerEnded()
}

let INSTANCE_TIMER : ReloadTimer = ReloadTimer()
class ReloadTimer: NSObject
{
    var pausedSeconds = 0
    
    weak var refreshSecondsTimer:Timer!
    
    fileprivate var refreshTimerSeconds:Int!
    fileprivate var delegates = [ReloadTimerDelegates]()
    
    class var getInstance: ReloadTimer
    {
        return INSTANCE_TIMER
    }
    
    func addDelegate(delegate:ReloadTimerDelegates)
    {
        delegates.append(delegate)
    }
    
    func removeDelegate(delegate:ReloadTimerDelegates)
    {
        for (index, oneDelegate) in delegates.enumerated().reversed() {
            if oneDelegate === delegate as AnyObject
            {
                delegates.remove(at: index)
                break
            }
        }
    }
    
    func isReloadTimerRunning() -> Bool
    {
        return (self.refreshSecondsTimer != nil)
    }
    
    func startingNewAutoRefreshBy(seconds:Int)
    {
        if ConstantsVO.reloadInEvent != .SECONDS_0
        {
            self.stopRefreshCountTimer()
            
            self.refreshTimerSeconds = seconds
            self.refreshSecondsTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.refreshTimerSeconds > 0 {
                    self.invokeDelegates(delegateMethod: { $0.reloadTimerCountdown(value: "Refreshing in Seconds: " + String(self.refreshTimerSeconds)) })
                    self.refreshTimerSeconds -= 1
                } else {
                    self.refreshSecondsTimer.invalidate()
                    self.refreshSecondsTimer = nil
                    self.invokeDelegates(delegateMethod: { $0.onTimerEnded() })
                }
            }
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "E, dd MM yyyy HH:mm:ss Z"
            self.invokeDelegates(delegateMethod: { $0.lastUpdatedOn(datetime: "Last updated on: " + formatter.string(from: now)) })
        }
        else
        {
            self.stopRefreshCountTimer()
        }
    }
    
    func stopRefreshCountTimer()
    {
        if (self.refreshSecondsTimer != nil)
        {
            self.refreshSecondsTimer.invalidate()
            self.refreshSecondsTimer = nil
            
            self.invokeDelegates(delegateMethod: { $0.reloadTimerCountdown(value: "Auto-refresh: STOPPED") })
        }
    }
    
    func pauseRefreshCountTimer()
    {
        if (self.refreshSecondsTimer != nil)
        {
            self.refreshSecondsTimer.invalidate()
            self.refreshSecondsTimer = nil
            self.pausedSeconds = self.refreshTimerSeconds
        }
    }
    
    func restartPausedCounter()
    {
        if (ConstantsVO.reloadInEvent.self.rawValue != 0) && (self.pausedSeconds != 0)
        {
            self.startingNewAutoRefreshBy(seconds: self.pausedSeconds)
            self.pausedSeconds = 0
        }
    }
    
    fileprivate func invokeDelegates(delegateMethod: (ReloadTimerDelegates) -> ())
    {
        for delegate in delegates
        {
            delegateMethod(delegate)
        }
    }
}
