//
//  SecondViewController.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 31/08/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import UIKit

struct SettingsVO
{
    let title:String!
    var value:String!
    let requireIndicator:Bool!
}

protocol SettingsPickerViewDelegate
{
    func updateSettingsWith(value:Dictionary<String, Any>)
}

class SettingsViewController: UIViewController
{
    @IBOutlet weak var tableMenu: UITableView!
    
    var categories = [SettingsVO]()
    var dataManager = DataManager.getInstance
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableMenu.backgroundColor = UIColor.clear
        
        categories.append(
            SettingsVO(title: "Non-critical Alerts", value: "ON", requireIndicator: true)
        )
        categories.append(
            SettingsVO(title: "Refresh in Every", value: "60 Seconds", requireIndicator: true)
        )
        categories.append(
            SettingsVO(title: "Auto-refresh Data", value: "ON", requireIndicator: true)
        )
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment]
    {
        return self.tableMenu.preferredFocusEnvironments
    }
}

extension SettingsViewController:UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell") as? SettingsUITableViewCell
        cell?.textLabel?.text = categories[indexPath.row].title + ": " + categories[indexPath.row].value
        cell?.backgroundColor = UIColor.white
        cell?.accessoryType = categories[indexPath.row].requireIndicator ? .disclosureIndicator : .none
        
        cell?.textLabel?.textColor = UIColor.black
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let pickerView = UIStoryboard.pickerViewController()
        {
            var segmentItems:[Dictionary<String, Any>]!
            switch indexPath.row {
            case 0:
                segmentItems = [["label": "Non-critical ON", "value": true], ["label": "Non-critical OFF", "value": false]]
                break
            case 1:
                segmentItems = ReloadSecondsOption.listValue
                break
            default:
                segmentItems = [["label": "Refresh ON", "value": true], ["label": "Refresh OFF", "value": false]]
            }
            
            pickerView.modalPresentationStyle = .blurOverFullScreen
            pickerView.segmentItems = segmentItems
            pickerView.delegate = self
            present(pickerView, animated: true, completion: nil)
        }
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    {
        return IndexPath(row: 0, section: 0)
    }
}

extension SettingsViewController:SettingsPickerViewDelegate
{
    func updateSettingsWith(value:Dictionary<String, Any>)
    {
        let menuSelectionIndex = self.tableMenu.indexPathForSelectedRow?.row
        if menuSelectionIndex == 0
        {
            if let nonCriticalOn = (value["value"] as? Bool)
            {
                self.categories[menuSelectionIndex!].value = nonCriticalOn ? "ON" : "OFF"
                if ConstantsVO.showNonCriticalAlerts != nonCriticalOn
                {
                    ConstantsVO.showNonCriticalAlerts = nonCriticalOn
                    if nonCriticalOn
                    {
                        self.dataManager.releaseFilterCriticalAlerts()
                    }
                    else
                    {
                        self.dataManager.filterCriticalAlerts()
                    }
                    
                    if let cachedAlertItemsController = ConstantsVO.alertItemsView.object(forKey: "alertItemsTableViewController")
                    {
                        cachedAlertItemsController.reloadListing()
                    }
                }
            }
        }
        else if menuSelectionIndex == 1
        {
            self.categories[menuSelectionIndex!].value = value["label"] as? String
            ConstantsVO.reloadInEvent = value["value"] as! ReloadSecondsOption
        }
        else if menuSelectionIndex == 2
        {
            if let autoEnabled = (value["value"] as? Bool)
            {
                self.categories[menuSelectionIndex!].value = autoEnabled ? "ON" : "OFF"
                if ConstantsVO.autoReloadEventEnabled != autoEnabled
                {
                    ConstantsVO.autoReloadEventEnabled = autoEnabled
                    if !ConstantsVO.autoReloadEventEnabled
                    {
                        self.dataManager.stopAutoRefreshTimer()
                    }
                    else
                    {
                        self.dataManager.restartAutoRefreshTimer()
                    }
                }
            }
        }
        
        DispatchQueue.main.async{
            self.tableMenu.reloadData()
        }
    }
}
