//
//  FspLoginViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/26.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

//用户自己的登录账号
let CONFIG_USE_ID_KEY = "config use id key"
//自定义的appid
let CONFIG_APP_ID_KEY = "config_app_id_key"
//自定义的app_secret
let CONFIG_APP_SECRET_KEY = "config_app_secret_key"
//自定义的服务器地址
let CONFIG_SERVER_ADDRESS_KEY = "config_server_address_key"

let fps_manager = fsp_manager

class FspLoginViewController: FspToolViewController {

    lazy var settingVC: FspSettingViewController = {
        let settingVC = FspSettingViewController.init(nibName: "FspSettingViewController", bundle: Bundle.main)
        return settingVC
    }()

    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var InputUserIdField: UITextField!
    let titleNameLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 32, height: 23)))

    lazy var rightBarButton: UIBarButtonItem = {
        let button = UIButton.init()
        button.setImage(UIImage(named: "setting")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(leftBarButtonDidClick), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        let rightBarButton = UIBarButtonItem.init(customView: button)
        return rightBarButton
    }()
    
    var fspListVC: FspListViewController?
    
    
    @objc
    func leftBarButtonDidClick() -> Void {
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @IBOutlet weak var topMasonry: NSLayoutConstraint!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            let top = self.view.safeAreaInsets.top
            self.topMasonry.constant = top + 62.0;
            
        } else {
            // Fallback on earlier versions
            self.topMasonry.constant =  62.0 + (self.navigationController?.navigationBar.frame.size.height)!
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyBoardEvent()
        // Do any additional setup after loading the view.
        
        self.versionLabel.text = "SdkVersion: " + FspEngine.getVersionInfo() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "登录"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarButton
        let user_id = UserDefaults.standard.string(forKey: CONFIG_USE_ID_KEY)
        if user_id != nil {
            self.InputUserIdField.text = user_id
        }
        
        fsp_manager.keyBoardVC = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fsp_manager.keyBoardVC = nil
        if self.InputUserIdField.isFirstResponder {
            self.InputUserIdField.resignFirstResponder()
        }
        
    }
    
    @IBAction func inputUserIdEditingEnd(_ sender: Any) {
        //let str = self.InputUserIdField.text! as NSString
        //if str.length > 0 {
            //self.LoginBtn.isEnabled = true
        //}else{
            //self.LoginBtn.isEnabled = false
        //}
    }

    @IBAction func LoginBtnDidClick(_ sender: Any) {
        DebugLogTool.debugLog(item: "logging Btn Did click")
        
        if self.InputUserIdField.text?.count == 0 {
            DebugLogTool.debugLog(item: "用户ID不能为空")
            FspTools.showAlert(msg: "用户ID不能为空!")
            return
        }
        
        //MARK:测试
        //let vc = fsp_manager.cur_controller as! FspToolViewController
        //vc.showListVC()
        //return
        
        //登录
        let token = FspTokenFile.token(SecretKey, appid: AppId, groupID: "", userid: self.InputUserIdField.text!)
        let status = fps_manager.login(token: token, userId: self.InputUserIdField.text)

        //保存user_id
        UserDefaults.standard.set(self.InputUserIdField.text, forKey: CONFIG_USE_ID_KEY)
        if status == FspErrCode.FSP_ERR_OK {
            
            print(1)
    
        }else{
            
            print(0)
        }

    }
    

    
    override func showListVC() -> Void {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        fspListVC = FspListViewController.init(nibName:"FspListViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(fspListVC!, animated: true)
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.InputUserIdField.resignFirstResponder()
    }
    
    
    func addKeyBoardEvent() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShowNoti(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHideNoti(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    @objc func keyBoardWillShowNoti(noti: Notification) -> Void {
        let userInfo = noti.userInfo
        
        if fsp_manager.keyBoardVC != nil {
            if (fsp_manager.keyBoardVC!.isKind(of: FspToolViewController.self)){
                print(222)
                let vc = fsp_manager.keyBoardVC as! FspToolViewController
                vc.boardWillShowUp(noti: noti as NSNotification)
                
            }
        }
    }
    
    override func boardWillHideUp(noti: NSNotification) {
        print("FspLoginViewController hide")
    }
    
    override func boardWillShowUp(noti: NSNotification) {
        print("FspLoginViewController show")
    }
    
    @objc func keyBoardWillHideNoti(noti: Notification) -> Void {
        if fsp_manager.keyBoardVC != nil {
            if (fsp_manager.keyBoardVC!.isKind(of: FspToolViewController.self)){
                print(333)
                let vc = fsp_manager.keyBoardVC as! FspToolViewController
                vc.boardWillHideUp(noti: noti as NSNotification)
            }
        }
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
