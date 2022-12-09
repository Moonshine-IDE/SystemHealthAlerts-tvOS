//
//  WelcomeViewController.swift
//  SystemHealthAlerts
//
//  Created by Devsena on 04/11/22.
//  Copyright © 2022 Devsena. All rights reserved.
//

import UIKit

class WelcomeViewController:UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func onButtonPressed(_ sender: Any)
    {
        present(UIStoryboard.loggedInViewController()!, animated: false)
    }
}
