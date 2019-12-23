//
//  FspSettingViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/26.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

class FspSettingViewController: FspToolViewController {

    @IBOutlet weak var appServerAdressInput: UITextField!
    @IBOutlet weak var appSecretInput: UITextField!
    @IBOutlet weak var appIdTextInput: UITextField!
    @IBOutlet weak var switchConfigBtn: UISwitch!
    @IBOutlet weak var settingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchConfigBtn.isEnabled = true
        let use_custom_id = UserDefaults.standard.bool(forKey: CONFIG_KEY_USECONFIG)
        self.switchConfigBtn.isOn = !use_custom_id
        
        var strAppId = UserDefaults.standard.string(forKey: CONFIG_KEY_APPID) ?? ""
        var strSecretKey = UserDefaults.standard.string(forKey: CONFIG_KEY_SECRECTKEY) ?? ""
        var strServerAddr = UserDefaults.standard.string(forKey: CONFIG_KEY_SERVETADDR) ?? ""
        
        if strAppId.count != 0 {
            appIdTextInput.text =  strAppId
        }
        
        if strSecretKey.count != 0 {
            appSecretInput.text = strSecretKey
        }
        
        if strServerAddr.count == 0 {
            strServerAddr = ""
        }
        
        appServerAdressInput.text = strServerAddr
        
        // Do any additional setup after loading the view.
    }

    @IBAction func switchConfigDidValueChanged(_ sender: Any) {
        self.showOrhideSettingView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "设置"
        let use_custom_id = !UserDefaults.standard.bool(forKey: CONFIG_KEY_USECONFIG)
        self.switchConfigBtn.isOn = use_custom_id
        self.showOrhideSettingView()
    }
    
    func showOrhideSettingView() -> Void {
        if self.switchConfigBtn.isOn {
            self.settingView.isHidden = true
            DebugLogTool.debugLog(item: "使用默认配置")
            UserDefaults.standard.set(false, forKey: CONFIG_KEY_USECONFIG)
        }else{
            self.settingView.isHidden = false
            DebugLogTool.debugLog(item: "使用自定义配置")
            UserDefaults.standard.set(true, forKey: CONFIG_KEY_USECONFIG)
        }
        UserDefaults.standard.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideKeyBoard()
        let strAppId = appIdTextInput.text
        let strSecretKey = appSecretInput.text
        let strServerAddr = appServerAdressInput.text
        if self.switchConfigBtn.isOn {
            UserDefaults.standard.set(false, forKey: CONFIG_KEY_USECONFIG)
            UserDefaults.standard.set(strAppId, forKey: CONFIG_KEY_APPID)
            UserDefaults.standard.set(strSecretKey, forKey: CONFIG_KEY_SECRECTKEY)
            UserDefaults.standard.set(strServerAddr, forKey: CONFIG_KEY_SERVETADDR)
        }else{
            UserDefaults.standard.set(true, forKey: CONFIG_KEY_USECONFIG)
            UserDefaults.standard.set(strAppId, forKey: CONFIG_KEY_APPID)
            UserDefaults.standard.set(strSecretKey, forKey: CONFIG_KEY_SECRECTKEY)
            UserDefaults.standard.set(strServerAddr, forKey: CONFIG_KEY_SERVETADDR)
        }
        
        self.navigationController?.navigationBar.shadowImage = FspTools.createImageWithColor(color: .clear)
        
        return
        /*暂时不支持销毁fsp,重构*/
        if strAppId!.count == 0 || strSecretKey!.count == 0 || strServerAddr!.count == 0 {
            //用回默认
            //啥都不改
            UserDefaults.standard.set(false, forKey: CONFIG_KEY_USECONFIG)
        }else{
            
            UserDefaults.standard.set(true, forKey: CONFIG_KEY_USECONFIG)
            UserDefaults.standard.set(strAppId, forKey: CONFIG_KEY_APPID)
            UserDefaults.standard.set(strSecretKey, forKey: CONFIG_KEY_SECRECTKEY)
            UserDefaults.standard.set(strServerAddr, forKey: CONFIG_KEY_SERVETADDR)
            
            
        }
        
        let theApp = UIApplication.shared.delegate as! AppDelegate
        theApp.resetManager.sendNext(nil)
    }
    
    @objc
    func leftBarButtonDidClick() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyBoard()
    }
    
    func hideKeyBoard() -> Void {
        self.appIdTextInput.resignFirstResponder()
        self.appSecretInput.resignFirstResponder()
        self.appServerAdressInput.resignFirstResponder()
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
