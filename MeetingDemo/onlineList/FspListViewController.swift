//
//  FspListViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/27.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

class FspListViewController: FspToolViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,FspInviteViewControllerDelegate {
    func FspInviteViewControllerDidClickRefuseBtn() {
        let code = fsp_manager.rejectInvite(nInviteUserId: self.inviterUser!, nInviteId: Int32(self.inviteId!))
        if code == FspErrCode.FSP_ERR_OK {
            DebugLogTool.debugLog(item: "拒绝邀请成功")
        }else{
            DebugLogTool.debugLog(item: "拒绝邀请失败")
        }
    }
    
    func FspInviteViewControllerDidClickEnsureBtn() {
        let code = fsp_manager.acceptInvite(nInviteUserId: self.inviterUser!, nInviteId: Int32(self.inviteId!))
        if code == FspErrCode.FSP_ERR_OK {
            DebugLogTool.debugLog(item: "进入会议室")
           _ = fsp_manager.joinGroup(groupId: self.groupId)
        }else{
            DebugLogTool.debugLog(item: "进入会议室失败")
        }
    }
    
    func FspInviteViewControllerDidDisappear() {
        DebugLogTool.debugLog(item: "FspInviteViewControllerDidDisappear 移除")
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.textField?.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listDataSourceArr.count == 0 {
            return 0
        }
        return listDataSourceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! FspListTableViewCell
        cell.selectionStyle = .none
        let dataReSource = self.listDataSourceArr
        let model = dataReSource.object(at: indexPath.row) as! listStatusModel
        cell.userID.text = model.user_id
        if model.user_id == fsp_manager.user_id {
            //自己
            cell.userID.text = model.user_id + "（我）"
            cell.choseImage.isHidden = true
        }else{
            cell.choseImage.isHidden = false
        }
        
        if model.is_online == 1 {
            //在线
            cell.statusView.backgroundColor = UIColor.init(red: 83.0/255, green: 217.0/255, blue: 114.0/255, alpha: 1.0)
            cell.statusLabel.text = "在线"
        }else{
            //下线
            cell.choseImage.isHighlighted = false
            cell.statusView.backgroundColor = .red
            cell.statusLabel.text = "下线"
        }
        
        /*
        if model.userId == fsp_manager.user_id {
            //自己
            cell.userID.text = model.userId + "(我)"
            cell.choseImage.isHighlighted = true
            //默认选中
            cellStatus.add(indexPath)
        }
 */
        cell.choseImage.isHighlighted = model.is_selected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lock.lock()
        DispatchQueue.main.async {
            let text = indexPath.row
            let model = self.listDataSourceArr[text] as! listStatusModel
            if model.user_id == fsp_manager.user_id{
                self.lock.unlock()
                self.textField?.resignFirstResponder()
                return
            }
            model.is_selected = !model.is_selected
            self.listDataSourceArr.replaceObject(at: text, with: model)
            self.listTableView.reloadData()
        }
        lock.unlock()
        self.textField?.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    var group_id = ""

    @IBOutlet weak var textField: UITextField!
    @IBAction func textFieldDidEditEnd(_ sender: Any) {
        group_id = textField.text!
    }
    
    var listDataSourceArr: NSMutableArray = NSMutableArray()
    
    func searchSelectedSource(selectedStr: String) -> Bool {
        var ret = true
        for (_, value) in self.dataSource!.enumerated() {
            let strValue = value as! NSString
            let range = strValue.contains(selectedStr)
            if range != false{
                selectedSourceArr.add(strValue)
                ret = false
            }else{
                continue
            }
        }
        return ret
    }
    

    @IBOutlet weak var listTableView: UITableView!

    //查找的资源数组
    lazy var selectedSourceArr: NSMutableArray = {
        let selectedSourceArr = NSMutableArray()
        return selectedSourceArr
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib.init(nibName: "FspListTableViewCell", bundle: Bundle.main)
        self.listTableView .register(cellNib, forCellReuseIdentifier: "reuseCell")
        self.listTableView.separatorColor = .clear
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var topMasonry: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
      
        fsp_manager.keyBoardVC = self
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fsp_manager.keyBoardVC = nil
    }
    

    
    @IBOutlet weak var header: UIView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //self.addKeyBoardEvent()
        if #available(iOS 11.0, *) {
            let top = self.view.safeAreaInsets.top
            self.topMasonry.constant = top + 44
        }else{
            self.topMasonry.constant = 20 + 44
        }
    }
    

    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapgestureDidClick))
        return tap
    }()
    
    
    
    override func boardWillHideUp(noti: NSNotification) {
        print("FspListViewController hide")
        self.listTableView.removeGestureRecognizer(tap)
    }
    
    override func boardWillShowUp(noti: NSNotification) {
        print("FspListViewController show")
         self.listTableView.addGestureRecognizer(tap)
    }
    
    @objc
    func tapgestureDidClick() -> Void {
        self.textField?.resignFirstResponder()
    }
    

    
    @IBAction func callBtnDidClick(_ sender: Any) {
        self.textField?.resignFirstResponder()
        
        let group_str = NSString.init(string: self.textField.text!)
        
        if group_str.length == 0 {
            DebugLogTool.debugLog(item: "组名不能为空")
            FspTools.showAlert(msg: "组名不能为空!")
            return
        }
        //MARK:测试
        for model in self.listDataSourceArr {
            let cur_model = model as! listStatusModel
            if cur_model.is_selected == true{
                fsp_manager.call_userIds.append(cur_model.user_id)
            }
        }
        
        print(fsp_manager.call_userIds.count)
       _ = fsp_manager.joinGroup(groupId: self.textField.text)
    }
    
    var fspMeetingView: FspMeetingViewController?
    
    
    override func switchToMainVc() -> Void {
         fspMeetingView = FspMeetingViewController.init(nibName: "FspMeetingViewController", bundle: Bundle.main)
        print("跳转会议页面")
        fsp_manager.cur_controller = fspMeetingView
        self.navigationController?.pushViewController(fspMeetingView!, animated: true)
    }
    

    var lock = NSLock()
    override func updateListTableView(dataSourceArr: NSMutableArray) -> Void {
        let ret = lock.try()
        DispatchQueue.main.async {
            let minArr = NSMutableArray()
            var isFind = false
            for model in dataSourceArr {
                let newModel = model as! FspUserInfo
                for fs in self.listDataSourceArr {
                    let oldModel = fs as! listStatusModel
                    if oldModel.user_id == newModel.userId{
                        //老模型里面有新的模型，则保存
                        let model = listStatusModel()
                        if newModel.userStatus == FspUserStatus.FSP_USER_STATUS_ONLINE{
                            model.is_online = 1
                        }else if newModel.userStatus == FspUserStatus.FSP_USER_STATUS_OFFLINE{
                            model.is_online = 0
                        }
                        model.is_selected = oldModel.is_selected
                        model.user_id = newModel.userId
                        minArr.add(model)
                        isFind = true
                        break
                    }else{
                        isFind = false
                    }
                    
                    
                }
                
                if isFind == false{
                    //老模型里面没有新的模型，则直接添加新的
                    let model = listStatusModel()
                    if newModel.userStatus == FspUserStatus.FSP_USER_STATUS_ONLINE{
                        model.is_online = 1
                    }else if newModel.userStatus == FspUserStatus.FSP_USER_STATUS_OFFLINE{
                        model.is_online = 0
                    }
                    model.is_selected = false
                    model.user_id = newModel.userId
                    minArr.add(model)
                    continue;
                }
                
            }
            
            self.listDataSourceArr.removeAllObjects()
            self.listDataSourceArr.addObjects(from: minArr as! [Any])
            self.listTableView.reloadData()
        }
        
        if ret == true {
            lock.unlock()
        }
        
    }
    
    
    override func showInvite(InviterUserId: String, groupId: String, inviteId: Int, message: String) {
        DispatchQueue.main.async {
            self.receiveMeetingInviteMessage(InviterUserId: InviterUserId, groupId: groupId, inviteId: inviteId, message: message)
        }
    }
    
    lazy var InviteVC: FspInviteViewController = {
        let InviteVC = FspInviteViewController.init(nibName: "FspInviteViewController", bundle: Bundle.main)
        InviteVC.delegate = self
        return InviteVC
    }()
    
    func receiveMeetingInviteMessage(InviterUserId: String, groupId: String, inviteId: Int, message: String) -> Void {
        DebugLogTool.debugLog(item: "收到呼叫邀请")
        self.showInviteVc(InviterUserId: InviterUserId, groupId: groupId, inviteId: inviteId, message: message)
    }
    
    var groupId: String?
    var inviterUser: String?
    var inviteId: Int?
    var extraMsg: String?
    
    func showInviteVc(InviterUserId: String, groupId: String, inviteId: Int, message: String) -> Void {
        self.groupId = groupId
        self.inviterUser = InviterUserId
        self.inviteId = inviteId
        self.extraMsg = message
        
        let window = UIApplication.shared.keyWindow
        window?.addSubview((InviteVC.view)!)
        InviteVC.view.frame = CGRect(x: self.view.frame.origin.x, y: -1 * self.view.bounds.size.height, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        InviteVC.inviter_user_id_label.text = InviterUserId
        InviteVC.groupId = groupId
        InviteVC.inviterUser = InviterUserId
        InviteVC.inviteId = inviteId
        InviteVC.extraMsg = message
        InviteVC.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.InviteVC.view.frame = (window?.frame)!
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            self.InviteVC.view.isUserInteractionEnabled = true
        })
        
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
