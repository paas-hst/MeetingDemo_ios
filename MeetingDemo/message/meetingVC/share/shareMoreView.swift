//
//  shareMoreView.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/8/8.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit
typealias whiteBoardBlock = () -> ()
typealias sreenShareBlcok = (Bool) -> ()
typealias fileShareBlock = () -> ()

class shareMoreView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var whiteBoardBlock: whiteBoardBlock?
    var sreenShareBlcok: sreenShareBlcok?
    var fileShareBlock: fileShareBlock?
    
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
    
    lazy var whiteBoardShareVc: UIView = {
        let setVC = UIView()
        setVC.backgroundColor = .clear
        return setVC
    }()
    
    lazy var screenShareVC: UIView = {
        let recordVC = UIView()
        recordVC.backgroundColor = .clear
        return recordVC
    }()
    
    lazy var fileShareVC: UIView = {
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
    
    lazy var fileShareBtn: FspButton = {
        let fileShareBtn = FspButton()
        fileShareBtn.setImage(UIImage.init(named: "fileShare"), for: UIControl.State.normal)
        fileShareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 5)
        fileShareBtn.setTitleColor(UIColor.init(red: 86.0/255, green: 86.0/255, blue: 86.0/255, alpha: 1.0), for: .normal)
        fileShareBtn.setTitle("共享文件", for: .normal)
        fileShareBtn.addTarget(self, action: #selector(fileShareBtnDidClick), for: .touchUpInside)
        return fileShareBtn
    }()
    
    lazy var screenShareBtn: FspButton = {
        let screenShareBtn = FspButton()
        screenShareBtn.setImage(UIImage.init(named: "screen_share"), for: UIControl.State.normal)
        screenShareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 5)
        screenShareBtn.setTitleColor(UIColor.init(red: 86.0/255, green: 86.0/255, blue: 86.0/255, alpha: 1.0), for: .normal)
        screenShareBtn.setTitle("共享屏幕", for: .normal)
        screenShareBtn.isSelected = false
        screenShareBtn.addTarget(self, action: #selector(screenShareBtnDidClick), for: .touchUpInside)
        return screenShareBtn
    }()
    
    lazy var whiteBoardBtn: FspButton = {
        let whiteBoardBtn = FspButton()
        whiteBoardBtn.setImage(UIImage.init(named: "whiteBoardShare"), for: UIControl.State.normal)
        whiteBoardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 5)
        whiteBoardBtn.setTitleColor(UIColor.init(red: 86.0/255, green: 86.0/255, blue: 86.0/255, alpha: 1.0), for: .normal)
        whiteBoardBtn.setTitle("共享白板", for: .normal)
        whiteBoardBtn.addTarget(self, action: #selector(whiteBoardBtnDidClick), for: .touchUpInside)
        return whiteBoardBtn
    }()
    
    @objc
    func fileShareBtnDidClick() -> Void {
        DebugLogTool.debugLog(item: "点击了文件共享按钮")
        if self.fileShareBlock != nil {
            self.fileShareBlock!()
        }
    }
    
    @objc
    func screenShareBtnDidClick() -> Void {
        DebugLogTool.debugLog(item: "点击了共享屏幕按钮")
        if self.sreenShareBlcok != nil {
            self.sreenShareBlcok!(screenShareBtn.isSelected)
        }
    }
    
    @objc
    func whiteBoardBtnDidClick() -> Void {
        DebugLogTool.debugLog(item: "点击了白板共享按钮")
        if self.whiteBoardBlock != nil {
            self.whiteBoardBlock!()
        }
    }
    
    func setupUI() -> Void {
        self.addSubview(fileShareVC)
        self.addSubview(seperatorLineOne)
        self.addSubview(screenShareVC)
        self.addSubview(seperatorLineTwo)
        self.addSubview(whiteBoardShareVc)
        
        fileShareVC.addSubview(fileShareBtn)
        screenShareVC.addSubview(screenShareBtn)
        whiteBoardShareVc.addSubview(whiteBoardBtn)
        
        fileShareVC.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 50))
            make?.top.equalTo()(self.mas_top)
            make?.left.equalTo()(self.mas_left)
        }
        
        seperatorLineOne.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 1))
            make?.top.equalTo()(self.mas_top)?.offset()(50)
        }
        
        screenShareVC.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 50))
            make?.top.equalTo()(self.fileShareVC.mas_bottom)
            make?.left.equalTo()(self.mas_left)
        }
        
        seperatorLineTwo.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 1))
            make?.top.equalTo()(self.mas_top)?.offset()(100)
        }
        
        whiteBoardShareVc.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 50, height: 50))
            make?.top.equalTo()(self.screenShareVC.mas_bottom)
            make?.left.equalTo()(self.mas_left)
        }
        
        fileShareBtn.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 24, height: 30))
            make?.centerX.equalTo()(self.fileShareVC.mas_centerX)
            make?.centerY.equalTo()(self.fileShareVC.mas_centerY)
        }
        
        screenShareBtn.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 24, height: 30))
            make?.centerX.equalTo()(self.screenShareVC.mas_centerX)
            make?.centerY.equalTo()(self.screenShareVC.mas_centerY)
        }
        
        whiteBoardBtn.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 24, height: 30))
            make?.centerX.equalTo()(self.whiteBoardShareVc.mas_centerX)
            make?.centerY.equalTo()(self.whiteBoardShareVc.mas_centerY)
        }
        
    }

}
