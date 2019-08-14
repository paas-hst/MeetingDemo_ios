//
//  moreView.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/29.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

typealias callBlock = () -> ()
typealias recordBlcok = (Bool) -> ()
typealias settingBlock = () -> ()
class moreView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var callBlock: callBlock?
    var recordBlcok: recordBlcok?
    var settingBlock: settingBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    lazy var setVC: UIView = {
        let setVC = UIView()
        setVC.backgroundColor = .clear
        return setVC
    }()
    
    lazy var recordVC: UIView = {
        let recordVC = UIView()
        recordVC.backgroundColor = .clear
        return recordVC
    }()
    
    lazy var callVC: UIView = {
        let callVC = UIView()
        callVC.backgroundColor = .clear
        return callVC
    }()
    
    lazy var seperatorLineOne: UIView = {
        let seperatorLineOne = UIView()
        seperatorLineOne.backgroundColor = UIColor.init(red: 208.0/255, green: 215.0/255, blue: 223.0/255, alpha: 1.0)
        return seperatorLineOne
    }()
    
    lazy var seperatorLineTwo: UIView = {
        let seperatorLineTwo = UIView()
        seperatorLineTwo.backgroundColor = UIColor.init(red: 208.0/255, green: 215.0/255, blue: 223.0/255, alpha: 1.0)
        return seperatorLineTwo
    }()
    
    lazy var setVCBtn: FspButton = {
        let setVCBtn = FspButton()
        setVCBtn.setImage(UIImage.init(named: "消息 copy 4"), for: UIControl.State.normal)
        setVCBtn.titleLabel?.font = UIFont.systemFont(ofSize: 7)
        setVCBtn.setTitleColor(UIColor.init(red: 86.0/255, green: 86.0/255, blue: 86.0/255, alpha: 1.0), for: .normal)
        setVCBtn.setTitle("设置", for: .normal)
        setVCBtn.addTarget(self, action: #selector(showSettingVCBtnDidClick), for: .touchUpInside)
        return setVCBtn
    }()
    
    lazy var recordVCBtn: FspButton = {
        let recordVCBtn = FspButton()
        recordVCBtn.setImage(UIImage.init(named: "消息 copy 3"), for: UIControl.State.normal)
        recordVCBtn.titleLabel?.font = UIFont.systemFont(ofSize: 7)
        recordVCBtn.setTitleColor(UIColor.init(red: 86.0/255, green: 86.0/255, blue: 86.0/255, alpha: 1.0), for: .normal)
        recordVCBtn.setTitle("录制", for: .normal)
        recordVCBtn.isSelected = false
        recordVCBtn.addTarget(self, action: #selector(recoredAndPauseBtnDidClick), for: .touchUpInside)
        return recordVCBtn
    }()
    
    lazy var callVCBtn: FspButton = {
        let callVCBtn = FspButton()
        callVCBtn.setImage(UIImage.init(named: "消息 copy 2"), for: UIControl.State.normal)
        callVCBtn.titleLabel?.font = UIFont.systemFont(ofSize: 7)
        callVCBtn.setTitleColor(UIColor.init(red: 86.0/255, green: 86.0/255, blue: 86.0/255, alpha: 1.0), for: .normal)
        callVCBtn.setTitle("呼叫", for: .normal)
        callVCBtn.addTarget(self, action: #selector(callBtnDidClick), for: .touchUpInside)
        return callVCBtn
    }()
    
    @objc
    func showSettingVCBtnDidClick() -> Void {
        DebugLogTool.debugLog(item: "点击了设置按钮")
        if self.settingBlock != nil {
            self.settingBlock!()
        }
    }
    
    @objc
    func recoredAndPauseBtnDidClick() -> Void {
        DebugLogTool.debugLog(item: "点击了录制按钮")
        if self.recordBlcok != nil {
            self.recordBlcok!(recordVCBtn.isSelected)
        }
    }
    
    @objc
    func callBtnDidClick() -> Void {
        DebugLogTool.debugLog(item: "点击了呼叫按钮")
        if self.callBlock != nil {
            self.callBlock!()
        }
    }
    
    
    func setupUI() -> Void {
        self.addSubview(setVC)
        self.addSubview(seperatorLineOne)
        self.addSubview(recordVC)
        self.addSubview(seperatorLineTwo)
        self.addSubview(callVC)
        
        setVC.addSubview(setVCBtn)
        recordVC.addSubview(recordVCBtn)
        callVC.addSubview(callVCBtn)
        
        setVC.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 50))
            make?.top.equalTo()(self.mas_top)
            make?.left.equalTo()(self.mas_left)
        }
        
        seperatorLineOne.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 1))
            make?.top.equalTo()(self.mas_top)?.offset()(50)
        }
        
        recordVC.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 50))
            make?.top.equalTo()(self.setVC.mas_bottom)
            make?.left.equalTo()(self.mas_left)
        }
        
        seperatorLineTwo.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 1))
            make?.top.equalTo()(self.mas_top)?.offset()(100)
        }
        
        callVC.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 50))
            make?.top.equalTo()(self.recordVC.mas_bottom)
            make?.left.equalTo()(self.mas_left)
        }
        
        setVCBtn.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 24, height: 30))
            make?.centerX.equalTo()(self.setVC.mas_centerX)
            make?.centerY.equalTo()(self.setVC.mas_centerY)
        }
        
        recordVCBtn.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 24, height: 30))
            make?.centerX.equalTo()(self.recordVC.mas_centerX)
            make?.centerY.equalTo()(self.recordVC.mas_centerY)
        }
        
        callVCBtn.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 24, height: 30))
            make?.centerX.equalTo()(self.callVC.mas_centerX)
            make?.centerY.equalTo()(self.callVC.mas_centerY)
        }
        
    }

}
