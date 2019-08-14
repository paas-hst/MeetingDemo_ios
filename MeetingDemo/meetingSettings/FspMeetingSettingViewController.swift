//
//  FspMeetingSettingViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/27.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit
import AVFoundation

class sessionPresetModel: NSObject {
    
    var preSetTitle = ""
    var isChoosen = true
    var sessionPreset: AVCaptureSession.Preset?
    let titleColor: UIColor = UIColor.init(red: 35.0/255, green: 25.0/255, blue: 22.0/255, alpha: 1.0)
    var video_width = 352
    var video_height = 288
    override init() {
        super.init()
    }
    
}

typealias LoginOutBlock = () -> ()
class FspMeetingSettingViewController: FspToolViewController,UIPickerViewDelegate, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionPresetModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //选择发送消息列表
        var cell = tableView.dequeueReusableCell(withIdentifier: chooseSendUrsIdViewCell) as? FspMsgChooseSendCell
        if cell == nil {
            cell = FspMsgChooseSendCell(style: .default, reuseIdentifier: chooseSendUrsIdViewCell) as FspMsgChooseSendCell
        }
        
        cell!.selectionStyle = .none
        cell!.backgroundColor = .white
        
        let msgModel = sessionPresetModels[indexPath.row]
        cell?.isChoosen.isHidden =  !msgModel.isChoosen
        cell?.uerIdLabel.text = msgModel.preSetTitle
        cell?.uerIdLabel.textColor = msgModel.titleColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //选择分辨率
        let seletedModel = self.sessionPresetModels[indexPath.row]
        seletedModel.isChoosen = true
        
        for otherModel in self.sessionPresetModels
        {
            if otherModel != seletedModel{
                otherModel.isChoosen = false
            }
        }
        
        default_video_width = seletedModel.video_width
        default_video_height = seletedModel.video_height
        
        tableView.reloadData()
        self.updateSendMessageBtnTitleWithPresetModel(presetModel: seletedModel)
    }
    
    func updateSendMessageBtnTitleWithPresetModel(presetModel: sessionPresetModel) -> Void {
        DispatchQueue.main.async {
            self.presetChooseBtn.setTitle(presetModel.preSetTitle, for: .normal)
        }
        
    }

    
    var loginOutBlock: LoginOutBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.autoOpenCameraSwitch.isOn = fsp_manager.AutoOpenCamera!
        self.autoOpenMicPhoneSwitch.isOn = fsp_manager.AutoOpenMicPhone!
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
        self.view.addGestureRecognizer(tap)
  
        let chooseRresetTableViewNib = UINib.init(nibName: "FspMsgChooseSendCell", bundle: Bundle.main)
        self.presetTableView.register(chooseRresetTableViewNib, forCellReuseIdentifier: chooseSendUrsIdViewCell)
        self.presetTableView.separatorColor = .clear
        
        self.initDefaultSessionPreSetUI()

        // Do any additional setup after loading the view.
    }
    
    @objc
    func tap(tap: UITapGestureRecognizer) -> Void {
        if self.fspInputText.isFirstResponder {
            self.fspInputText.resignFirstResponder()
        }
        
        let fspStr = self.fspInputText.text!
        
        if fspStr.count == 0 {
            FspTools.showAlert(msg: "输入帧数不能为空,请重新设置！")
            self.fspInputText.text = String(default_fsp)
            return
        }
        
        if Int(fspStr)! < 10 {
            FspTools.showAlert(msg: "帧数不能小于10,请重新设置！")
            self.fspInputText.text = String(default_fsp)
            return
        }
        
        if Int(fspStr)! > 30 {
            FspTools.showAlert(msg: "帧数不能大于10,请重新设置！")
            self.fspInputText.text = String(default_fsp)
            return
        }
        
        if default_fsp != Int(fspStr)  {
            default_fsp = Int(fspStr)!
         
            _ = fsp_manager.setLocalVideoProfile(width: default_video_width, height: default_video_height, fps: default_fsp)
            
        }
        print("设置帧率 大小为", Int.init(fspStr) as Any)
    }
    
    //MARK: 分辨率选择
    func initDefaultSessionPreSetUI() -> Void {
        choosePresetCollection.enumerateObjects { (obj, idx, isStop) in
            let presetModel = sessionPresetModel()
            if idx == 0{
                //默认选中第一个
                presetModel.isChoosen = true
            }else{
                presetModel.isChoosen = false
            }
            presetModel.preSetTitle = sessionPresetDescription[idx]
            presetModel.sessionPreset = (choosePresetCollection[idx] as! AVCaptureSession.Preset)
            presetModel.video_width = widths[idx]
            presetModel.video_height = heights[idx]
            sessionPresetModels.append(presetModel)
        }
        
        self.presetTableView.reloadData()
    }
    
    
    @IBAction func presetBtnDidClick(_ sender: Any) {
        self.showChoosePresetChooseView()
    }
    
    lazy var choosePresetCollection: NSMutableArray = {
        var choosePresetCollection = NSMutableArray()
        
        if self.isSupportSesssionPreset(preset: AVCaptureSession.Preset.cif352x288)
        {
            choosePresetCollection.add(AVCaptureSession.Preset.cif352x288)
        }
        
        if self.isSupportSesssionPreset(preset: AVCaptureSession.Preset.vga640x480)
        {
            choosePresetCollection.add(AVCaptureSession.Preset.vga640x480)
        }
        
        if self.isSupportSesssionPreset(preset: AVCaptureSession.Preset.iFrame960x540)
        {
            choosePresetCollection.add(AVCaptureSession.Preset.iFrame960x540)
        }
        
        if self.isSupportSesssionPreset(preset: AVCaptureSession.Preset.hd1280x720)
        {
            choosePresetCollection.add(AVCaptureSession.Preset.hd1280x720)
        }
        
        if self.isSupportSesssionPreset(preset: AVCaptureSession.Preset.hd1920x1080)
        {
            choosePresetCollection.add(AVCaptureSession.Preset.hd1920x1080)
        }
        
        return choosePresetCollection
    }()
    
    private(set) var sessionPresetDescription: Array<String> = Array.init(arrayLiteral: "352*288","640*480","960*540","1280*720","1920*1080")
    
    private(set) var widths: Array<Int> = Array.init(arrayLiteral: 352,640,960,1280,1920)
    
    private(set) var heights: Array<Int> = Array.init(arrayLiteral: 288,480,540,720,1080)
    
    private(set) var sessionPresetModels: Array<sessionPresetModel> = Array<sessionPresetModel>()
    
    func isSupportSesssionPreset(preset: AVCaptureSession.Preset) -> Bool {
        let captureSession = AVCaptureSession()
        if (captureSession.canSetSessionPreset(preset)){
            return true
        }
        
        return false
    }
    
    @IBOutlet var sessionPresetChooseView: UIView!
    @IBOutlet weak var presetTableView: UITableView!
    @IBOutlet weak var presetChooseBtn: UIButton!
    
    @IBAction func hidePresetChooseViewBtnDidClick(_ sender: Any) {
        
        self.hideChoosePresetChooseView()
    }
    
    func hideChoosePresetChooseView() -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            
            //view.transform = CGAffineTransformScale(view.transform,
            // recognizer.scale, recognizer.scale)
            
            self.sessionPresetChooseView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.sessionPresetChooseView.alpha = 0
            
        }) { (finished) in
            let bgView = UIApplication.shared.keyWindow?.viewWithTag(2001)
            if bgView != nil {
                bgView?.removeFromSuperview()
                self.sessionPresetChooseView.removeFromSuperview()
            }else{
                bgView?.removeFromSuperview()
                self.sessionPresetChooseView.removeFromSuperview()
            }
            
        }
        
    }
    
    func showChoosePresetChooseView() -> Void {
        let oldView = UIApplication.shared.keyWindow?.viewWithTag(2001)
        if oldView != nil {
            oldView?.removeFromSuperview()
        }
        
        let bgView = UIView.init(frame: UIApplication.shared.keyWindow!.bounds)
        bgView.tag = 2001
        bgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        bgView.addGestureRecognizer(tap)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        UIApplication.shared.keyWindow?.addSubview(self.sessionPresetChooseView)
        self.sessionPresetChooseView.mas_makeConstraints { (make) in
            make?.top.equalTo()(UIApplication.shared.keyWindow?.mas_top)?.offset()(0)
            make?.bottom.equalTo()(UIApplication.shared.keyWindow?.mas_bottom)?.offset()(0)
            make?.left.equalTo()(UIApplication.shared.keyWindow?.mas_left)?.offset()(0)
            make?.right.equalTo()(UIApplication.shared.keyWindow?.mas_right)?.offset()(0)
        }
        self.sessionPresetChooseView.alpha = 0
        self.sessionPresetChooseView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25) {
            self.sessionPresetChooseView.transform = CGAffineTransform.identity
            self.sessionPresetChooseView.alpha = 1
        }
        
    }
    
    @objc
    func hide() -> Void {
        self.hideChoosePresetChooseView()
    }
    
    
    //MARK: 默认帧率
    var default_fsp = 15
    var default_video_width = 352
    var default_video_height = 288
    
    @IBOutlet weak var fspInputText: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "设置"
        let color = UIColor.init(red: 242.0/255, green: 242.0/255, blue: 242.0/255, alpha: 1.0)
        let shadowImage = FspTools.createImageWithColor(color: color)
        self.navigationController?.navigationBar.shadowImage = shadowImage
    }

    @IBOutlet weak var topMasonry: NSLayoutConstraint!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            let top = self.view.safeAreaInsets.top
            self.topMasonry.constant = top + 44
        } else {
            self.topMasonry.constant = 20 + 44
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.loginOutBlock != nil {
            self.loginOutBlock!()
        }
    }

    
    @IBOutlet weak var autoOpenMicPhoneSwitch: UISwitch!
    @IBOutlet weak var autoOpenCameraSwitch: UISwitch!
    @IBAction func autoOpenCameraBtnDidClick(_ sender: Any) {
        UserDefaults.standard.set(autoOpenCameraSwitch.isOn, forKey: isAutoOpenCamera)
    }
    @IBAction func autoOpenMicPhoneBtnDidClick(_ sender: Any) {
        UserDefaults.standard.set(autoOpenMicPhoneSwitch.isOn, forKey: isAutoOpenMicPhone)
    }
    
    
    
    @IBAction func backBtnDidClick(_ sender: Any) {
        
        
        _ = fsp_manager.setLocalVideoProfile(width: default_video_width, height: default_video_height, fps: default_fsp)
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func loginOutBtnDidClick(_ sender: Any) {
        
        _ = fsp_manager.stopPublishVideo()
        _ = fsp_manager.stopPublishAudio()
        
        _ = fsp_manager.leaveGroup()
        _ = fsp_manager.loginOut()

        let views = self.navigationController?.viewControllers
        var use_view: UIViewController?
        
        for view in views! {
            if view.isMember(of: FspLoginViewController.self){
                use_view = view
                break
            }
            
        }
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToViewController(use_view!, animated: true)
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
