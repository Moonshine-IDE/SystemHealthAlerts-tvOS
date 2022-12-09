//
//  UIExtensions.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 07/09/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard
{
    class func mainStoryboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func errorViewController() -> ErrorDisplayViewController?
    {
        return mainStoryboard().instantiateViewController(withIdentifier: "errorViewController") as? ErrorDisplayViewController
    }
    
    class func pickerViewController() -> PickerViewController?
    {
        return (mainStoryboard().instantiateViewController(identifier: "pickerAlertView") as? PickerViewController)
    }
    
    class func loggedInViewController() -> MenuTabBarControllerViewController?
    {
        return (mainStoryboard().instantiateViewController(identifier: "userView") as? MenuTabBarControllerViewController)
    }
}

extension Double
{
    func roundToDecimal(_ fractionDigits: Int) -> Double
    {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
