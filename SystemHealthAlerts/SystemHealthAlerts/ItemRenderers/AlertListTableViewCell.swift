//
//  AlertListTableViewCell.swift
//  SystemHealthAlerts
//
//  Created by Devsena on 03/09/20.
//  Copyright © 2020 Devsena. All rights reserved.
//

import UIKit

class AlertListTableViewCell: UITableViewCell
{
    static let COLOR_GRAY_SELECTED = UIColor.gray
    static let COLOR_RED_SELECTED = UIColor.red
    static let COLOR_LIGHT_GRAY_NORMAL = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.3)
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableSubList: UITableView!
    @IBOutlet weak var collectionSubList: UICollectionView!
    
    var items:[String]!
    
    fileprivate var critical = false
    
    func updateCell(with:AlertItemVO)
    {
        lblTitle.text = with.alertTitle()
        items = with.entries
        critical = with.critical
        
        lblTitle.font = critical ? lblTitle.font.withSize(22) : lblTitle.font.withSize(20)
        
        self.updateCellColors()
        updateTableConstraints()
        
        collectionSubList.reloadData()
    }
    
    func updateTableConstraints()
    {
        collectionSubList.mask = nil
        collectionSubList.delegate = self
        collectionSubList.dataSource = self
        //collectionViewHeightConstraint.constant = CGFloat(items.count * 36) - 15 //(cell.bounds.height - 1)+ 15
        collectionViewHeightConstraint.constant = CGFloat(items.count * 31)
        collectionSubList.layoutIfNeeded()
    }
    
    func updateCellColors()
    {
        self.accessoryType = .none
        
        if self.critical && !isSelected
        {
            self.contentView.backgroundColor = AlertListTableViewCell.COLOR_RED_SELECTED
            self.accessoryView?.backgroundColor = AlertListTableViewCell.COLOR_RED_SELECTED
            lblTitle.textColor = UIColor.white
        }
        else if isSelected
        {
            let bgColorView = UIView()
            bgColorView.backgroundColor = self.critical ? AlertListTableViewCell.COLOR_RED_SELECTED : AlertListTableViewCell.COLOR_GRAY_SELECTED
            self.selectedBackgroundView = bgColorView
            
            self.contentView.backgroundColor = self.critical ? AlertListTableViewCell.COLOR_RED_SELECTED : AlertListTableViewCell.COLOR_GRAY_SELECTED
            lblTitle.textColor = UIColor.white
            
            self.accessoryType = .disclosureIndicator
        }
        else
        {
            self.contentView.backgroundColor = AlertListTableViewCell.COLOR_LIGHT_GRAY_NORMAL
            lblTitle.textColor = UIColor.black
        }
    }
}

extension AlertListTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return ((items != nil) ? items.count : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "alertSubCollectionViewCell", for: indexPath) as? AlertSubCollectionViewCell
        cell?.lblTitle.text = items[indexPath.row]
        cell?.lblTitle.textColor = UIColor.black
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 31
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(kWhateverHeightYouWant))
    }
}
