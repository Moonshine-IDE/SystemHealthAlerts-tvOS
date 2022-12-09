//
//  ErrorDisplayViewController.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 04/09/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import UIKit

class ErrorDisplayViewController: UIViewController
{
    @IBOutlet weak var lblErrorDetails: UILabel!
    @IBOutlet weak var lblReloadCounter: UILabel!
    @IBOutlet weak var viewColored: UIView!
    
    lazy var reloadTimerUtil:ReloadTimer! =
    {
        var rtu = ReloadTimer.getInstance
        return rtu
    }()
    
    open var errorMessage = "Fetching details.."
    {
        didSet
        {
            let attributedString = NSMutableAttributedString(string: errorMessage)
            attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.black, range: NSRange(location: 0, length: errorMessage.count))
            self.lblErrorDetails.attributedText = attributedString
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        viewColored.layer.borderWidth = 2
        viewColored.layer.borderColor = UIColor.red.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        reloadTimerUtil.addDelegate(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        reloadTimerUtil.removeDelegate(delegate: self)
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

extension ErrorDisplayViewController: ReloadTimerDelegates
{
    func reloadTimerCountdown(value:String)
    {
        lblReloadCounter.text = value + "!"
    }
    
    func lastUpdatedOn(datetime:String)
    {
        
    }
    
    func onTimerEnded()
    {
        
    }
}
