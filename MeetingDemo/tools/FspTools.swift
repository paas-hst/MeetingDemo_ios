//
//  FspTools.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/26.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

//MARK:加入组
public let fsp_tool_join_group_success = "本机用户id:%@ 加入组id:%@ 成功!"

//MARK:本机推拉流行为
public let fsp_tool_local_audio_open = "本机用户id:%@ 打开音频，开始推送音频数据!"
public let fsp_tool_local_audio_close = "本机用户id:%@ 关闭音频，停止推送音频数据!"
public let fsp_tool_local_video_open = "本机用户id:%@ 打开摄像头，开始推送视频数据!"
public let fsp_tool_local_video_close = "本机用户id:%@ 关闭摄像头，停止推送视频数据!"

//MARK:远端推流行为
public let fsp_tool_remote_audio_open = "搜索到远端用户id:%@ 开始推送音频数据! 本机开始接收此音频流!"
public let fsp_tool_remote_audio_close = "搜索到远端用户id:%@ 停止推送音频数据! 本机停止接收此音频流!"
public let fsp_tool_remote_video_open = "搜索到远端用户id:%@ 开始推送视频数据! 本机开始接收此视频流!"
public let fsp_tool_remote_video_close = "搜索到远端用户id:%@ 停止推送视频数据! 本机停止接收此视频流!"


//MARK:屏幕共享行为
public let fsp_tool_screen_share_open = "搜索到远端用户id:%@ 屏幕共享流! 本机开始接收此视频流!"
public let fsp_tool_screen_share_close = "搜索到远端用户id:%@ 屏幕共享流已经关闭! 本机停止接收此视频流!"

//MARK: 主动邀请行为
public let fsp_tool_invitation_open = "本机id:%@ 向用户:%@ 发出与会邀请！邀请id:%d!"
public let fsp_tool_invitation_accept = "本机id:%@ 用户:%@ 已经接受此邀请，邀请id:%d!"
public let fsp_tool_invitation_reject = "本机id:%@ 用户:%@ 已经拒绝此邀请，邀请id:%d!"


class DebugLogTool: NSObject {
    static func debugLog(item: Any){
        #if DEBUG
             print(item)
        #else
        
        #endif
    }
    
}

class FspTools: NSObject {
  
    class func createImageWithColor(color: UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    class func showAlert(msg: String) -> Void {
         let showView = HHShowView.alertTitle("提示", message: msg)
        let action = HHAlertAction(title: "确定", style: .confirm) { (alert) in
            print("点击确定")
        }
        
        showView?.add(action)
        showView?.show()
    }
    
    class func getCalendar() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    

    class func createJoinGroupModelStr(user_id: String,group_id: String,eventStr: String) -> String{
        let modelStr = NSString(format: eventStr as NSString, user_id,group_id) as String
        return modelStr
    }
    
    class func createCustomModelStr(user_id: String,eventStr: String) -> String{
        let modelStr = NSString(format: eventStr as NSString, user_id) as String
        return modelStr
    }
    
    class func createInvitationModelStr(user_id: String,toUser_id: String,inviteID: Int,eventStr: String) -> String{
        let modelStr = NSString(format: eventStr as NSString, user_id,toUser_id,inviteID) as String
        return modelStr
    }
    

    
}
