//
//  FspAllChooseModel.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/30.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

class FspAllChooseModel: FspMsgSendModel {

    override init() {
        super.init()
        isChoosen = true
        titleColor = UIColor.init(red: 87.0/255, green: 128.0/255, blue: 255.0/255, alpha: 1.0)
    }

}
