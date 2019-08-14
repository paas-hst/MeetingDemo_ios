//
//  FspAttendeeModel.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/29.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit
/**
 * @brief 用于保存参会人状态
 *
 */
class FspAttendeeModel: NSObject {
    
    var useId: String!
    var isAudioOpen: Bool!
    var isCameraOpen: Bool!
    var isScreenShareOpen: Bool!
    
    override init() {
        useId = "测试"
        isAudioOpen = false
        isCameraOpen = false
        isScreenShareOpen = false
        super.init()
        
    }
    
    
}
