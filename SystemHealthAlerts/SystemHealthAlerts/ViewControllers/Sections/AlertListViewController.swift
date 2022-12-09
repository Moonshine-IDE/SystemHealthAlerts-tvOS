//
//  AlertListViewController.swift
//  SystemHealthAlerts
//
//  Created by Devsena on 03/09/20.
//  Copyright © 2020 Devsena. All rights reserved.
//

import UIKit

class AlertListViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblReloadCountdown: UILabel!
    @IBOutlet weak var lblLastLoaded: UILabel!
    @IBOutlet weak var lblRemoteMessage: UILabel!
    @IBOutlet weak var lblCriticalError: UILabel!
    @IBOutlet weak var lblLoadTime: UILabel!
    
    var spinner:UIActivityIndicatorView!
    
    private var errorViewController:ErrorDisplayViewController!
    
    lazy var dataManager: DataManager! =
    {
        var dm = DataManager.getInstance
        dm.delegate = self
        return dm
    }()
    
    lazy var reloadTimerUtil:ReloadTimer! =
    {
        var rtu = ReloadTimer.getInstance
        return rtu
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        reloadTimerUtil.addDelegate(delegate: self)
        ConstantsVO.alertItemsView.setObject(self, forKey: "alertItemsTableViewController")
        requestData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if self.errorViewController != nil
        {
            self.errorViewController.viewDidAppear(false)
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment]
    {
        return self.tableView.preferredFocusEnvironments
    }
    
    // MARK: - other methods
    
    func requestData()
    {
        DispatchQueue.main.async {
            self.updateSpinnerView(show: true)
            self.dataManager.requestData()
        }
    }
    
    func reloadListing()
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func showUIAlert(message:String)
    {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            //okay button handler
        }))
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func updateSpinnerView(show:Bool)
    {
        if (show)
        {
            spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = (self.errorViewController == nil) ? UIColor.red : UIColor.lightGray
            view.addSubview(spinner)

            spinner.translatesAutoresizingMaskIntoConstraints = false
            
            spinner.centerXAnchor.constraint(equalTo: (view.centerXAnchor)).isActive = true
            spinner.centerYAnchor.constraint(equalTo: (view.centerYAnchor)).isActive = true
            spinner.startAnimating()
        }
        else if (!show)
        {
            DispatchQueue.main.async{
                self.spinner.stopAnimating()
                self.view.willRemoveSubview(self.spinner)
            }
        }
    }
    
    fileprivate func updateTimeDetails()
    {
        DispatchQueue.main.async {
            self.lblRemoteMessage.text = self.dataManager.jsonData.message
        }
    }
    
    fileprivate func removeErrorView()
    {
        if self.errorViewController != nil
        {
            self.errorViewController.view.removeFromSuperview()
            self.errorViewController = nil
        }
    }
}

extension AlertListViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataManager.numberOfItemsInList()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertListTableCell") as! AlertListTableViewCell
        if let item = self.dataManager.alertItem(itemAtIndex: indexPath.row)
        {
            cell.updateCell(with: item)
        }
        
        return cell
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    {
        return IndexPath(row: 0, section: 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
}

extension AlertListViewController:DataManagerDelegates
{
    func dataUpdated()
    {
        DispatchQueue.main.async{
            self.tableView.reloadData()
            DispatchQueue.main.async{
                if self.dataManager.numberOfItemsInList() > 0
                {
                    self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                }

                self.updateSpinnerView(show: false)
                self.updateTimeDetails()
                self.removeErrorView()
                
                guard let tabBarController = self.tabBarController as? MenuTabBarControllerViewController else { return }
                tabBarController.dataUpdated()
            }
        }
    }
    
    @objc func dataUpdateFailed(error:String)
    {
        self.updateSpinnerView(show: false)
        DispatchQueue.main.async {
            if (self.errorViewController == nil), let errorView = UIStoryboard.errorViewController()
            {
                self.errorViewController = errorView
                self.view.addSubview(self.errorViewController.view)
            }
            
            self.errorViewController.errorMessage = error
            if (!self.reloadTimerUtil.isReloadTimerRunning())
            {
                self.reloadTimerUtil.startingNewAutoRefreshBy(seconds: ConstantsVO.reloadInEvent.self.rawValue)
            }
        }
    }
    
    @objc func jsonHasReportedError(error:String)
    {
        DispatchQueue.main.async {
            if error != ""
            {
                self.lblCriticalError.isHidden = false
                self.lblCriticalError.text = error
            }
            else if !self.lblCriticalError.isHidden
            {
                self.lblCriticalError.text = ""
                self.lblCriticalError.isHidden = true
            }
        }
    }
}

extension AlertListViewController:ReloadTimerDelegates
{
    func reloadTimerCountdown(value:String)
    {
        self.lblReloadCountdown.text = value
    }
    
    func lastUpdatedOn(datetime:String)
    {
        lblLastLoaded.text = datetime
        
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Failed: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]));
        text.append(NSAttributedString(string: String(self.dataManager.countFailure), attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange]))
        text.append(NSAttributedString(string: ", Success: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]));
        text.append(NSAttributedString(string: String(self.dataManager.countSuccess), attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange]))
        text.append(NSAttributedString(string: ", Average Loading Time(S): ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]));
        text.append(NSAttributedString(string: String(self.dataManager.averageLoadingTime), attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange]))
        lblLoadTime.attributedText = text
    }
    
    func onTimerEnded()
    {
        if ConstantsVO.reloadInEvent.self.rawValue != 0
        {
            self.requestData()
        }
    }
}
