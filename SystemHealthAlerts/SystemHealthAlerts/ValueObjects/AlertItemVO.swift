//
//  AlertItemVO.swift
//  SystemHealthAlerts
//
//  Created by Devsena on 31/08/20.
//  Copyright © 2020 Devsena. All rights reserved.
//

import Foundation

struct AlertItemVO:Decodable
{
    let name:String!
    let message:String!
    let entries:[String]!
    let critical:Bool!
    
    func alertTitle() -> String {
        return name + " (" + ((message != nil) ? message : "") + ")"
    }
}
