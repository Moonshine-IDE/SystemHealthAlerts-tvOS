//
//  AlertSubCollectionViewCell.swift
//  SystemHealthAlerts
//
//  Created by Santanu Karar on 10/09/20.
//  Copyright © 2020 Santanu Karar. All rights reserved.
//

import UIKit

class AlertSubCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    
    override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(1.0)
        context!.setStrokeColor(UIColor.lightGray.cgColor)
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        context!.strokePath()
    }
}
