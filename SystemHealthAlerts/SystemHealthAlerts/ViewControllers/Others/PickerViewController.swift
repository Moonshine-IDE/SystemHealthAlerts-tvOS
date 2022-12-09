//
//  PickerViewController.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 01/09/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController
{
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var segmentItems:[Dictionary<String, Any>]!
    
    var delegate:SettingsPickerViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        OperationQueue.main.addOperation {
            self.segmentControl.removeAllSegments()
            for (index, segment) in self.segmentItems.enumerated()
            {
                self.segmentControl.insertSegment(withTitle: segment["label"] as? String, at: index, animated: false)
            }
        }
    }

    @IBAction func onSegmentSelected(_ sender: Any)
    {
        print(segmentControl.selectedSegmentIndex)
    }
    
    @IBAction func onAcceptButton(_ sender: Any)
    {
        delegate.updateSettingsWith(value: segmentItems[segmentControl.selectedSegmentIndex])
        DispatchQueue.main.async
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
