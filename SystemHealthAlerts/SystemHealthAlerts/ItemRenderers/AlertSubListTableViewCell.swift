//
//  AlertSubListTableViewCell.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 03/09/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import UIKit

class AlertSubListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var markerCritical: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
