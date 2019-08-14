//
//  FspAttendeeUsrInfo.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/7/10.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit
//参会人详情 用于动态更新页面 和列表不一致
class FspAttendeeUsrInfo: NSObject {
    /*
     本参会人第一个显示，保证永远能看到
     */
    var is_forceShow = false
    /*
     本参会人视频ID
    */
    var video_id = ""
    /*
     本参会人用户ID
    */
    var user_id = ""
    /*
     本参会人是否发布了视频流,如果为false
     */
    var is_videoOpen = false
    /*
     本参会人是否发布了音频流
    */
    var is_audioOpen = false
    /*
     本次参会人是否是屏幕共享流
     */
    var is_ScreenShare = false
    /*
     远端视频已发布，但是本地无法显示，因为cell不足，当本地cell有参会人退出时，依次显示
     */
    var is_nextShow = false
    /*
     正在显示
    */
    var is_shown = false;
    
    override init() {
        super.init()
        
    }
    
}
