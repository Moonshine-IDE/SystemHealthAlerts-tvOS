//
//  MenuTabBarControllerViewController.swift
//  SystemHealthAlerts
//
//  Created by Devsena on 01/09/20.
//  Copyright © 2020 Devsena. All rights reserved.
//

import UIKit

class MenuTabBarControllerViewController: UITabBarController
{
    private var needFocusToMoveIntoAlertView = true
    private var isDataOnceBeingFetched = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // retrieve the current device appearance
        ConstantsVO.isDarkMode = (self.traitCollection.userInterfaceStyle == .dark) ? true : false
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment]
    {
        let environments: [UIFocusEnvironment]
        
        if needFocusToMoveIntoAlertView, isDataOnceBeingFetched, (selectedIndex == 0),
            let cachedAlertItemsController = ConstantsVO.alertItemsView.object(forKey: "alertItemsTableViewController")
        {
            environments = cachedAlertItemsController.preferredFocusEnvironments
            needFocusToMoveIntoAlertView = false
        }
        else
        {
            environments = self.tabBar.preferredFocusEnvironments
        }
        
        return environments
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func dataUpdated()
    {
        if !isDataOnceBeingFetched
        {
            isDataOnceBeingFetched = true
            self.setNeedsFocusUpdate()
        }
    }
}
