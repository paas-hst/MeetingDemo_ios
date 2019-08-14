//
//  FspInviteViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/26.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit
protocol FspInviteViewControllerDelegate {
    func FspInviteViewControllerDidDisappear()
    func FspInviteViewControllerDidClickRefuseBtn()
    func FspInviteViewControllerDidClickEnsureBtn()
}

class FspInviteViewController: FspToolViewController {

    var delegate: FspInviteViewControllerDelegate?
    
    var groupId: String?
    var inviterUser: String?
    var inviteId: Int?
    var extraMsg: String?
    
    @IBOutlet weak var inviter_user_id_label: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        self.view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    @IBAction func acceptBtnDidClick(_ sender: Any) {
        DebugLogTool.debugLog(item: "接受")
        self.hideView()
        //发送接受的消息
        if self.delegate != nil {
            self.delegate?.FspInviteViewControllerDidClickEnsureBtn()
        }
    }
    
    @IBAction func CancleBtnDidClick(_ sender: Any) {
        self.refuseCalling()
        //发送拒绝的消息
        if self.delegate != nil {
            self.delegate?.FspInviteViewControllerDidClickRefuseBtn()
        }
    }
    
    func hideView() -> Void {
        UIView.animate(withDuration: 0.5) {
            self.view.frame = CGRect(x: (self.view.superview?.frame.origin.x)!, y: -1 * (self.view.superview?.bounds.size.height)!, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.75) {
            self.view.removeFromSuperview()
        }
    }
    
    func refuseCalling() -> Void {
        DebugLogTool.debugLog(item: "拒绝")
        self.hideView()
        
        //发送拒绝的消息
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (self.delegate != nil){
            self.delegate!.FspInviteViewControllerDidDisappear()
        }
    }
    
    deinit {
        DebugLogTool.debugLog(item: "FspInvite dealloc")
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
