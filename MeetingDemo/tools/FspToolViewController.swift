//
//  FspToolViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/27.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

typealias messageBlockCallBack = () -> ()
typealias messageModelBlockCallBack = (FspMessageModel) -> ()




class FspToolViewController: UIViewController {

    var dataSource: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage.init(named: "icon-back")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(image: image, style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        dataSource = NSMutableArray()
        
        // Do any additional setup after loading the view.
    }
    
    func onReceiveUserMsg(_ nSrcUserId: String, msg nMsg: String, msgId nMsgId: Int32) -> Void {
        
        
    }
    
    func onReceiveGroupMsg(_ nSrcUserId: String, msg nMsg: String, msgId nMsgId: Int32) -> Void {
        
        
    }
    
    func onGroupUsersRefreshed(userIds: Array<String>) -> Void {
        
    }
    
    func onGroupUserJoined(userId: String) {

    }
    
    func onGroupUserLeaved(userId: String) {
  
    }
    
    func runSynMessageModelUpdate(messageBlock: messageModelBlockCallBack,model: FspMessageModel) -> Void {
    
        if Thread.current == fsp_manager.messageDataQueue {
            messageBlock(model)
        }else{
            fsp_manager.messageDataQueue.sync {
                messageBlock(model)
            }
        }
    }
    
    func runSynMessageUpdate(messageBlock: messageBlockCallBack) -> Void {
        
        if Thread.current == fsp_manager.messageDataQueue {
            messageBlock()
        }else{
            fsp_manager.messageDataQueue.sync {
                messageBlock()
            }
        }
    }
    
    func updateListTableView(dataSourceArr: NSMutableArray) -> Void {
        dataSource!.removeAllObjects()
        dataSource!.addObjects(from: dataSourceArr as! [Any])
    }
    
    func showListVC() -> Void {

    }
    
    func switchToMainVc() -> Void {
        
    }
    
    func remoteVideoEvent(_ userId: String, videoId: String, eventType: FspRemoteVideoEventType) -> Void{
        
    }
    
    func remoteAudioEvent(_ userId: String, eventType: FspRemoteAudioEventType)-> Void {
 
    }
    
    func showInvite(InviterUserId: String, groupId: String, inviteId: Int,message: String) -> Void {
        
    }
    
    func boardWillShowUp(noti: NSNotification) -> Void {
        
        
    }
    
    func boardWillHideUp(noti: NSNotification) -> Void {
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
