//
//  FspChooseModel.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/30.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

class FspChooseModel: FspMsgSendModel {
    var userId = ""
    override init() {
        super.init()
        isChoosen = false
        titleColor = UIColor.init(red: 35.0/255, green: 25.0/255, blue: 22.0/255, alpha: 1.0)
    }
    
}
