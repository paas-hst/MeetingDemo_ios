//
//  FspManager.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/25.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

var AppId: String = "925aa51ebf829d49fc98b2fca5d963bc"
var SecretKey: String = "d52be60bb810d17e"
var ServerAddr: String = ""

//var AppId: String = "6ae85fefeb24bc16158d6a0be8eb9266"
//var SecretKey: String = "e8cab8a26f60cd4a"
//var ServerAddr: String = "http://192.168.7.201:20020/server/address"

class listStatusModel: NSObject {
    var user_id = ""
    //1 代表在线 0代表下线
    var is_online = 1
    //是否选中
    var is_selected = false
}

class FspMgrDataTypeLogin: NSObject {
    var eventType: FspEventType = FspEventType(rawValue: -1)!
    var code: FspErrCode = FspErrCode(rawValue: -1)!
    
    override init() {
        super.init()
    }
    
    deinit {
        print(superclass as Any)
    }
}

class FspMgrRemoteVideo: NSObject {
    var eventType: FspRemoteVideoEventType = FspRemoteVideoEventType(rawValue: -1)!
    var code: String = ""
    var userID: String = ""
    override init() {
        super.init()
    }
    deinit {
        print(superclass as Any)
    }
}

class FspMgrRemoteAudio: NSObject {
    var eventType: FspRemoteAudioEventType = FspRemoteAudioEventType(rawValue: -1)!
    var userID: String = ""
    override init() {
        super.init()
    }
    deinit {
        print(superclass as Any)
    }
}

//配置
let isAutoOpenCamera = "isAutoOpenCamera"
let isAutoOpenMicPhone = "isAutoOpenMicPhone"


let CONFIG_KEY_USECONFIG = "fspuseconfig_key"
let CONFIG_KEY_APPID = "fspappid_key"
let CONFIG_KEY_SECRECTKEY = "fspsecretkey_key"
let CONFIG_KEY_SERVETADDR = "fspserveraddr_key"
typealias jumpBlock = (String) -> ()


protocol FspManagerRemoteEventDelegate {
    func remoteVideoEvent(_ userId: String, videoId: String, eventType: FspRemoteVideoEventType)
    func remoteAudioEvent(_ userId: String, eventType: FspRemoteAudioEventType)
}

protocol FspManagerRemoteSignallingDelegate {
    func onInviteIncome(_ InviterUserId: String, inviteId nInviteId: Int32, groupId nGroupId: String, msg message: String?)
    func onInviteAccepted(_ RemoteUserId: String, inviteId nInviteId: Int32)
    func onInviteRejected(_ RemoteUserId: String, inviteId nInviteId: Int32)
}

class FspManager: NSObject,FspEngineDelegate,FspEngineMsgDelegate,FspEngineSignalingDelegate {
    func onGroupUserJoined(_ userId: String) {
        if cur_controller != nil {
            let vc = cur_controller as! FspToolViewController
            vc.onGroupUserJoined(userId: userId)
        }
    }
    
    func onGroupUserLeaved(_ userId: String) {
        if cur_controller != nil {
            let vc = cur_controller as! FspToolViewController
            vc.onGroupUserLeaved(userId: userId)
        }
    }
    
    func onGroupUsersRefreshed(_ userIds: [String]) {
        
        if curGroupUsers.count > 0 {
            curGroupUsers.removeAll()
        }
    
        for userId in userIds {
            let attendeeModel = FspAttendeeModel()
            attendeeModel.useId = userId
            curGroupUsers.append(attendeeModel)
        }
        
        if cur_controller != nil {
            let vc = cur_controller as! FspToolViewController
            vc.onGroupUsersRefreshed(userIds: userIds)
        }
    }
    
    func onUserStatusChanged(_ remoteUserId: String, newStatus nNewStatus: FspUserStatus){
        print(remoteUserId,"change！")
    }
    
    func onReceiveUserMsg(_ nSrcUserId: String, msg nMsg: String, msgId nMsgId: Int32) {
       // DispatchQueue.main.sync {
            if cur_controller != nil {
                let vc = cur_controller as! FspToolViewController
                vc.onReceiveUserMsg(nSrcUserId, msg: nMsg, msgId: nMsgId)
            }
       // }
    }
    
    func onReceiveGroupMsg(_ nSrcUserId: String, msg nMsg: String, msgId nMsgId: Int32) {
       // DispatchQueue.main.sync {
            if cur_controller != nil {
                let vc = cur_controller as! FspToolViewController
                vc.onReceiveGroupMsg(nSrcUserId, msg: nMsg, msgId: nMsgId)
            }
      //  }
    }
    
    //初次进入会议室内 组内的成员
    private(set) var curGroupUsers: Array<FspAttendeeModel> = Array<FspAttendeeModel>()
    
    //MARK:VERSION
    private(set) var version = FspEngine.getVersionInfo()

    //呼叫用户数组
    var call_userIds = Array<String>()
    
    //MARK:用户自身的群组id和userid以及事件和信令事件代理
    public var groupID: String?
    public var userID: String?
    var delegate:  FspManagerRemoteEventDelegate?
    var singallingDelegate: FspManagerRemoteSignallingDelegate?
    
    
    func fspEvent(_ eventType: FspEventType, errCode: FspErrCode) {
        if eventType == FspEventType.FSP_EVENT_LOGIN_RESULT {
            if errCode == FspErrCode.FSP_ERR_OK {
            //登录成功
               DispatchQueue.main.async {
                    DebugLogTool.debugLog(item: "登录成功")
                    self.hud!.hide(animated: true)
                    self.hud = nil
                    //开始刷新列表
                _ = self.refreshModelTimer
                self.refreshModelTimer.fireDate = Date.distantPast
               }
            
                DispatchQueue.main.sync {
                     if cur_controller != nil {
                        let vc = cur_controller as! FspToolViewController
                        vc.showListVC()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    DebugLogTool.debugLog(item: "登录失败")
                    DispatchQueue.main.async {
                        self.hud!.hide(animated: true)
                        self.hud = nil
                        let str = NSString.init(format: "%d", Int(Float(errCode.rawValue)))
                        FspTools.showAlert(msg: "登录失败，错误码是：" + (str as String))
                    }
                    
                }
           }
        }
        
        if eventType == .FSP_EVENT_JOINGROUP {
            if errCode == FspErrCode.FSP_ERR_OK{
                DebugLogTool.debugLog(item: "加入组成功")
                DispatchQueue.main.sync {
                    self.hud!.hide(animated: true)
                    self.hud = nil
                    if self.cur_controller != nil {
                        let vc = self.cur_controller as! FspToolViewController
                        vc.switchToMainVc()
                    }
                }
            }else{
                DebugLogTool.debugLog(item: "加入组失败")
                DispatchQueue.main.sync {
                    //alert
                    self.hud!.hide(animated: true)
                    self.hud = nil
                    let str = NSString.init(format: "%d", Int(Float(errCode.rawValue)))
                    FspTools.showAlert(msg: "加入组失败,错误码是：" + (str as String))
                }
            }
            
        }
    }
    

    func onInviteIncome(_ InviterUserId: String, inviteId nInviteId: Int32, groupId nGroupId: String, msg message: String?) {
        DebugLogTool.debugLog(item: "收到邀请的消息，弹出邀请界面")
        DispatchQueue.main.sync {
            if cur_controller != nil {
                let vc = cur_controller as! FspToolViewController
                vc.showInvite(InviterUserId: InviterUserId, groupId: nGroupId, inviteId: Int(nInviteId), message: message!)
            }
            
        }
    }
    
    func onInviteAccepted(_ RemoteUserId: String, inviteId nInviteId: Int32) {
        
    }
    
    func onInviteRejected(_ RemoteUserId: String, inviteId nInviteId: Int32) {
        
    }
    
    
    func refreshUserStatusFinished(_ errCode: FspErrCode, requestId nRequestId: UInt32, usrInfo models: NSMutableArray) {
        DispatchQueue.main.sync {
            if cur_controller != nil {
                let vc = cur_controller as! FspToolViewController
                vc.updateListTableView(dataSourceArr: models)
            }
            
        }
    }
    

    lazy var refreshModelTimer: Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshModel(timer:)), userInfo: nil, repeats: true)
        timer.fireDate = Date.distantFuture
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        return timer
    }()
    
    @objc
    func refreshModel(timer: Timer) -> Void {
        //DebugLogTool.debugLog(item: "刷新列表")
        _ = fsp_manager.UserStatusRefresh(userIds: nil)
        
    }
    
    func remoteVideoEvent(_ userId: String, videoId: String, eventType: FspRemoteVideoEventType) {
        //接收或者移除远端视频
        if cur_controller != nil {
            let vc = cur_controller as! FspToolViewController
            if Thread.isMainThread {
                vc.remoteVideoEvent(userId, videoId: videoId, eventType: eventType)
            }else{
                DispatchQueue.main.sync {
                    vc.remoteVideoEvent(userId, videoId: videoId, eventType: eventType)
                }
            }
            
        }
    }
    
    func remoteAudioEvent(_ userId: String, eventType: FspRemoteAudioEventType) {
        //接收或者移除远端音频
        DebugLogTool.debugLog(item: "接收音频")
        if cur_controller != nil {
            let vc = cur_controller as! FspToolViewController
            vc.remoteAudioEvent(userId, eventType: eventType)
        }
    }
    
    var cur_controller: UIViewController?
    var keyBoardVC: UIViewController?
    
    let jump: jumpBlock = {(str: String) -> () in
        print(str)
    }
    
    
    //MARK: fsp引擎
    private var fsp_engine: FspEngine?
    var user_id: String?
    var group_id: String?
    //MARK: 初始化
    static let sharedManager = FspManager()
    let messageDataQueue: DispatchQueue = DispatchQueue(label: "com.fsmeeting.message")
    //MARK: 配置
    var AutoOpenCamera: Bool? = UserDefaults.standard.bool(forKey: isAutoOpenCamera)
    var AutoOpenMicPhone: Bool? = UserDefaults.standard.bool(forKey: isAutoOpenMicPhone)
    
    
    override init() {
        super.init()
        
        _ = AutoOpenMicPhone
        _ = AutoOpenCamera
        if AutoOpenCamera == nil {
            UserDefaults.standard.set(true, forKey: isAutoOpenCamera)
        }
        
        if AutoOpenMicPhone == nil {
            UserDefaults.standard.set(true, forKey: isAutoOpenMicPhone)
        }

    }
    
    
    //MARK:登录 methods
    func login(nToken : String, nUserid: String) -> FspErrCode {
        return self.fsp_engine!.login(nToken, userId: nUserid)
    }
    
    func loginOut() -> FspErrCode {
        return self.fsp_engine!.loginOut()
    }
    
    //MARK: 群组 methods
    func joinGroup(nGroup: String) -> FspErrCode {
        return self.fsp_engine!.joinGroup(nGroup)
    }
    
    func leaveGroup() -> FspErrCode {
        return self.fsp_engine!.leaveGroup()
    }
    
    //MARK:销毁
    func destoryFsp() -> FspErrCode {
        self.fsp_engine!.destoryFsp()
        self.fsp_engine = nil
        return FspErrCode.FSP_ERR_OK
    }
    
    //MARK: Signaling methods
    func userStatusRefresh(nUserIds: NSArray?, nRequestId: UnsafeMutablePointer<UInt32>) -> FspErrCode {
        return self.fsp_engine!.userStatusRefresh(nUserIds as? [String], requestId: nRequestId)
    }
    
    func inviteUser(nUsersId: Array<String>!, nGroupId: String, nExtraMsg: String, nInviteId: UnsafeMutablePointer<UInt32>) -> FspErrCode {
        return self.fsp_engine!.inviteUser(nUsersId, groupId: nGroupId, extraMsg: nExtraMsg, inviteId: nInviteId)
    }
    
    func acceptInvite(nInviteUserId: String, nInviteId: Int32) -> FspErrCode {
        return self.fsp_engine!.acceptInvite(nInviteUserId, inviteId: nInviteId)
    }
    
    func rejectInvite(nInviteUserId: String, nInviteId: Int32) -> FspErrCode {
        return self.fsp_engine!.rejectInvite(nInviteUserId, inviteId: nInviteId)
    }
    
    func initFsp() -> Bool {
        
        if (fsp_engine != nil) {
            fsp_engine = nil
        }
        var strAppId: String = ""
        var strSecretKey: String = ""
        var strServerAddr: String = ""
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        let useConfigVal = UserDefaults.standard.bool(forKey: CONFIG_KEY_USECONFIG)
        if useConfigVal == true {
            strAppId = UserDefaults.standard.string(forKey: CONFIG_KEY_APPID) ?? ""
            strSecretKey = UserDefaults.standard.string(forKey: CONFIG_KEY_SECRECTKEY) ?? ""
            strServerAddr = UserDefaults.standard.string(forKey: CONFIG_KEY_SERVETADDR) ?? ""
        }else{
             strAppId = AppId
             strSecretKey = SecretKey
             strServerAddr = ServerAddr
        }
        
        if (strAppId.count <= 0 || strSecretKey.count <= 0) {
             return false
        }
    
        print("%%%%%%%%%%%%%%%%%%%%%%")
        print("############# %@,%@,%@",strAppId,strSecretKey,strServerAddr)
        
        SecretKey = strSecretKey
        AppId = strAppId
        ServerAddr = strServerAddr
        
        fsp_engine = FspEngine.sharedEngine(withAppId: strAppId, logPath: documentPath, serverAddr: strServerAddr, delegate: self)
        if fsp_engine != nil {
            return true
        }
        return false
    }
    
    var hud: MBProgressHUD?
    func login(token: String!, userId: String!) -> FspErrCode {
        if fsp_engine != nil {
            self.user_id = userId
            if hud == nil{
                hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                hud!.contentColor = UIColor.init(red: 0.0, green: 0.6, blue: 0.7, alpha: 1.0)
                hud!.label.text = "正在登录"
                hud!.label.textColor = .white
               
            }
            hud!.show(animated: true)
            let errCode = fsp_engine!.login(token, userId: userId)
            if errCode != FspErrCode.FSP_ERR_OK {
                DispatchQueue.main.async {
                    DebugLogTool.debugLog(item: "登录失败")
                    DispatchQueue.main.async {
                        self.hud!.hide(animated: true)
                        self.hud = nil
                        let str = NSString.init(format: "%d", Int(Float(errCode.rawValue)))
                        FspTools.showAlert(msg: "登录失败，错误码是：" + (str as String))
                    }
                    
                }
            }
            return FspErrCode.FSP_ERR_FAIL
        }
        return FspErrCode.FSP_ERR_OK
    }
    

    func joinGroup(groupId: String!) -> FspErrCode {
        if fsp_engine != nil {
            group_id = groupId
            if hud == nil{
                hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                hud!.contentColor = UIColor.init(red: 0.0, green: 0.6, blue: 0.7, alpha: 1.0)
                hud!.label.text = "正在加入组..."
                hud!.label.textColor = .white
                
            }
            hud!.show(animated: true)
            let errCode = fsp_engine!.joinGroup(groupId)
            if errCode != FspErrCode.FSP_ERR_OK {
                DebugLogTool.debugLog(item: "加入组失败")
                DispatchQueue.main.sync {
                    //alert
                    self.hud!.hide(animated: true)
                    self.hud = nil
                    let str = NSString.init(format: "%d", Int(Float(errCode.rawValue)))
                    FspTools.showAlert(msg: "加入组失败,错误码是：" + (str as String))
                }
            }
            return FspErrCode.FSP_ERR_FAIL
        }
        return FspErrCode.FSP_ERR_OK
    }
    

    
    var requestId = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
    
    func UserStatusRefresh(userIds: NSArray?) -> FspErrCode {
        if fsp_engine != nil {
            return fsp_engine!.userStatusRefresh((userIds as? [String]), requestId: requestId)
        }
        return FspErrCode.FSP_ERR_OK
    }
    

    //MARK: Audio method
    private var isPublishingAudio: Bool?
    func startPublishAudio() -> FspErrCode {
        let code = self.fsp_engine!.startPublishAudio()
        if code == FspErrCode.FSP_ERR_OK {
            isPublishingAudio = true
        }else{
            isPublishingAudio = false
        }
        return code
    }
    func stopPublishAudio() -> FspErrCode {
        isPublishingAudio = false
        return self.fsp_engine!.stopPublishAudio()
    }
    
    //MARK: Video method
    private var isPublishingVideo: Bool?
    func stopPublishVideo() -> FspErrCode {
        let code = self.fsp_engine!.stopPublishVideo()
        isPublishingVideo = false
        return code
    }
    
    func startPublishVideo() -> FspErrCode {
        let code = self.fsp_engine!.startPublishVideo()
        if code == FspErrCode.FSP_ERR_OK {
            isPublishingVideo = true
        }else{
            isPublishingVideo = false
        }
        return code
    }
    
    func setVideoPreview(render: UIView) -> FspErrCode {
        let code = self.fsp_engine!.setVideoPreview(render)
        return code
    }
    
    func stopVideoPreview() -> FspErrCode {
        let code = self.fsp_engine!.stopVideoPreview()
        return code
    }
    
    func setRemoteVideoRender(userId: String, videoId: String, render: UIView?, mode: FspRenderMode) -> FspErrCode {
        let code = self.fsp_engine!.setRemoteVideoRender(userId, videoId: videoId, render: render, mode: mode)
        return code
    }
   
    
    var msgId = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
    func sendUsrMsg(nUserId: String!, nMsg: String!, nMsgId: UnsafeMutablePointer<UInt32>!) -> FspErrCode {
        return self.fsp_engine!.sendUserMsg(nUserId, msg: nMsg, msgId: msgId);
    }
    
    func sendGroupMsg(nMsg: String!, nMsgId: UnsafeMutablePointer<UInt32>!) -> FspErrCode {
        return self.fsp_engine!.sendGroupMsg(nMsg, msgId: msgId)
    }
    
    func setLocalVideoProfile(width: Int!, height: Int!, fps: Int!) -> FspErrCode {
        
        let localVideoProfile = FspVideoProfile(width, height: height, framerate: fps)
        return self.fsp_engine!.setVideoProfile(localVideoProfile)
    }
    
}
