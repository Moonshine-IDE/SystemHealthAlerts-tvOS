//
//  ConstantsVO.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 31/08/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import Foundation

enum ReloadSecondsOption:Int
{
    case SECONDS_0 = 0
    case SECONDS_30 = 30
    case SECONDS_60 = 60
    case SECONDS_120 = 120
    case SECONDS_180 = 180
    case SECONDS_300 = 300
    
    static var listValue: [Dictionary<String, Any>]
    {
        return [["label": "30 Seconds", "value": ReloadSecondsOption.self.SECONDS_30], ["label": "60 Seconds", "value": ReloadSecondsOption.self.SECONDS_60], ["label": "120 Seconds", "value": ReloadSecondsOption.self.SECONDS_120], ["label": "180 Seconds", "value": ReloadSecondsOption.self.SECONDS_180], ["label": "300 Seconds", "value": ReloadSecondsOption.self.SECONDS_300]]
    }
}

class ConstantsVO: NSObject
{
    static var reloadInEvent:ReloadSecondsOption = .SECONDS_60
    static var alertItemsView = NSCache<NSString, AlertListViewController>()
    static var autoReloadEventEnabled = true
    static var showNonCriticalAlerts = true
    static var isDarkMode = false
}
