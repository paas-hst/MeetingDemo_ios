//
//  FspMeetingViewController.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/28.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit
import AVFoundation

let FspViewCell = "FspViewCell"
let callViewCell = "callViewCell"
let attendeeViewCell = "callViewCell"
let chooseSendUrsIdViewCell = "chooseSendUrsIdViewCell"


enum LayoutType:Int {
    case LayoutTypeDefault = 0 //单屏
    case LayoutTypeThreefourths //双屏
    case LayoutTypeFourSplitScreen //四分屏
    case LayoutTypeSixSplitScreen //六分屏
}


let  GH_SCREENWIDTH = Double(exactly: UIScreen.main.bounds.size.width)
let  GH_SCREENHEIGH = Double(exactly: UIScreen.main.bounds.size.height)

var iScrollBottom = true
class FspMeetingViewController: FspToolViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource, FspCollectionViewCellDelegate,UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
    }
    

    func textViewDidEndEditing(_ textView: UITextView){
        
        
    }

    //MARK: FspCollectionViewCellDelegate
    func cellDoubleTap(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            let view = sender.view as! FspCollectionViewCell
            if view.isFullScreen == false {
                view.frame = CGRect(x: 0, y: 0, width: GH_SCREENWIDTH!, height: GH_SCREENHEIGH!)
                
                if view.user_id == fsp_manager.user_id {
                    
                    let layers = view.renderView.layer.sublayers
                    if layers != nil{
                        for sublayer in view.renderView.layer.sublayers!{
                            let layer = sublayer
                            layer.frame = view.bounds
                        }
                    }
                }
                
                
                view.isFullScreen = true
                for cell in self.collectionView.visibleCells {
                    let selectedCell = cell as! FspCollectionViewCell
                    if selectedCell.isFullScreen != true{
                        //selectedCell.isHidden = true
                        selectedCell.alpha = 0.0
                    }
                }
                
                
            }else{
                view.isFullScreen = false
                view.frame = view.originFrame!
                if view.user_id == fsp_manager.user_id {
                    
                    let layers = view.renderView.layer.sublayers
                    if layers != nil{
                        for sublayer in view.renderView.layer.sublayers!{
                            let layer = sublayer
                            layer.frame = view.bounds
                        }
                    }
                }
                for cell in self.collectionView.visibleCells {
                    let selectedCell = cell as! FspCollectionViewCell
                    if selectedCell.isFullScreen == false{
                        //selectedCell.isHidden = false
                        selectedCell.alpha = 1.0
                    }
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func cellSingleTap(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            if self.bottomView.alpha >= 0.9{
                self.bottomView.alpha = 0.0
            }else{
                self.bottomView.alpha = 1.0
            }
        }
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.bottomView.isHidden = !self.bottomView.isHidden
        //}
    }
    

    
    
    @IBOutlet weak var callingBackView: UIView!
    @IBOutlet weak var callBackTableList: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == callBackTableList {
            if self.listDataSourceArr.count == 0 {
                return 0
            }
            return self.listDataSourceArr.count
        }else if(tableView == MessageListView){
            //DebugLogTool.debugLog(item: "返回消息列表个数")
            return msgDataArr.count
        }else if(tableView == attendeeTableView){
            //参会人
            return attendeeStatusOnlineModel.count;
        }else{
            //选择发送消息
            return chooseSendBgViewArr.count;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == callBackTableList {
            return 60
        }else if (tableView == MessageListView){
            //DebugLogTool.debugLog(item: "返回消息列表高度")
            return (self.msgDataArr[indexPath.row] as! FspMessageModel).cellHeight()
        }else if (tableView == attendeeTableView){
            //参会人
            return 60;
        }else{
            //选择消息发送对象
            return 44;
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if iScrollBottom == false {
            tableView.selectRow(at: NSIndexPath(row: self.msgDataArr.count - 1, section: 0) as IndexPath, animated: true, scrollPosition: .middle)
            if indexPath.row == self.msgDataArr.count - 1 {
                iScrollBottom = true
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == callBackTableList {
            let cell = tableView.dequeueReusableCell(withIdentifier: callViewCell, for: indexPath) as! FspListTableViewCell
            cell.selectionStyle = .none
            let dataReSource = self.listDataSourceArr
            let model = dataReSource.object(at: indexPath.row) as! listStatusModel
            cell.userID.text = model.user_id
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
            
            if model.user_id == fsp_manager.user_id {
                //自己
                cell.userID.text = model.user_id + "(我)"
                cell.choseImage.isHidden = true
            }else{
                cell.choseImage.isHidden = false
            }
            
            cell.choseImage.isHighlighted = model.is_selected
            
            cell.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
            
            return cell
        }else if (tableView == MessageListView){
            //消息列表
            //DebugLogTool.debugLog(item: "返回消息列表cell")
            let cell = FspMsgCell.cellWithTableView(tableView: self.MessageListView, messageModel: self.msgDataArr[indexPath.row] as! FspMessageModel)
            cell.backgroundColor = UIColor.init(red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
            return cell
        }else if (tableView == attendeeTableView){
            //参会人
            var cell = tableView.dequeueReusableCell(withIdentifier: attendeeViewCell) as? FspAttendeeCell
            if cell == nil {
                cell = FspAttendeeCell(style: .default, reuseIdentifier: attendeeViewCell) as FspAttendeeCell
            }
            
            let attendeeStatusModel = self.attendeeStatusOnlineModel[indexPath.row] as! FspAttendeeModel
            if attendeeStatusModel.useId == fsp_manager.user_id{
                cell!.attendee_userid_textFiled.text = attendeeStatusModel.useId + "(我)"
            }else{
                cell!.attendee_userid_textFiled.text = attendeeStatusModel.useId
            }
            
            cell!.isAudioOpen = attendeeStatusModel.isAudioOpen
            cell!.isCameraOpen = attendeeStatusModel.isCameraOpen
            cell!.isScreenShareOpen = attendeeStatusModel.isScreenShareOpen
            cell?.selectionStyle = .none
            cell!.backgroundColor = .white
            return cell!
        }else{
            //选择发送消息列表
            var cell = tableView.dequeueReusableCell(withIdentifier: chooseSendUrsIdViewCell) as? FspMsgChooseSendCell
            if cell == nil {
                cell = FspMsgChooseSendCell(style: .default, reuseIdentifier: chooseSendUrsIdViewCell) as FspMsgChooseSendCell
            }
            
            cell!.selectionStyle = .none
            cell!.backgroundColor = .white
            
            let msgModel = chooseSendBgViewArr[indexPath.row] as! FspMsgSendModel
            if msgModel.isKind(of: FspAllChooseModel.self){
                //全部选择
                cell?.isChoosen.isHidden =  !(msgModel as! FspAllChooseModel).isChoosen
                cell?.uerIdLabel.text = "所有人"
                cell?.uerIdLabel.textColor = (msgModel as! FspAllChooseModel).titleColor
            }else{
                //单选
                cell?.isChoosen.isHidden =  !(msgModel as! FspChooseModel).isChoosen
                cell?.uerIdLabel.text = (msgModel as! FspChooseModel).userId
                cell?.uerIdLabel.textColor = (msgModel as! FspChooseModel).titleColor
            }
            
            return cell!
        }

    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == callBackTableList {
            lock.lock()
            DispatchQueue.main.async {
                let text = indexPath.row
                let model = self.listDataSourceArr[text] as! listStatusModel
                model.is_selected = !model.is_selected
                self.listDataSourceArr.replaceObject(at: text, with: model)
                self.callBackTableList.reloadData()
            }
            lock.unlock()
        }else if (tableView == MessageListView){
            DebugLogTool.debugLog(item: "返回消息列表选择")
            let cell = tableView.cellForRow(at: indexPath) as! FspMsgCell
            let index = NSIndexPath(row: msgDataArr.count - 1, section: 0)
            tableView.selectRow(at: index as IndexPath, animated: true, scrollPosition: .middle)

        }else if (tableView == attendeeTableView){
            //消息
            
        }else{
            //选择发送对象
            let seletedModel = self.chooseSendBgViewArr[indexPath.row] as! FspMsgSendModel
      
            chooseSendBgViewArr.enumerateObjects { (obj, idx, objcBool) in
                let attendeeObj = obj as! FspMsgSendModel
                if attendeeObj != seletedModel{
                    attendeeObj.isChoosen = false
                }else{
                    attendeeObj.isChoosen = true
                }
            }
          
            tableView.reloadData()
            
            var userId = ""
            if seletedModel.isKind(of: FspAllChooseModel.self){
                userId = "所有人"
            }else{
                userId = (seletedModel as! FspChooseModel).userId
            }
            self.updateSendMessageBtnTitleWithUsrId(userId: userId)
        }

    }
    

    @objc func copyTextWWW(menu: Any) -> Void {
        
    }
    
    //源资源数组
    lazy var listDataSourceArr: NSMutableArray = {
        let dataArr = NSMutableArray()
        return dataArr
    }()
    
    //消息数组
    lazy var msgDataArr: NSMutableArray = {
       let msgDataArr = NSMutableArray()
        return msgDataArr
    }()
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    //支持的参会人数
    var count = 1
    //实际的参会人
    var meeting_count = 1
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch layoutType {
        case .LayoutTypeDefault:
            count = 1
            break
        case .LayoutTypeThreefourths:
            count = 2
            break
        case .LayoutTypeFourSplitScreen:
            count = 4
            break
        case .LayoutTypeSixSplitScreen:
            count = 6
            break
        default:
            break
        }
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FspViewCell, for: indexPath)
        let newCell = cell as! FspCollectionViewCell
        newCell.delegate = self
        newCell.LoginView.isHidden = false
        newCell.user_id_label.text = ""
        newCell.renderView.isHidden = true
        newCell.originFrame = newCell.frame
        newCell.renderView.frame = newCell.bounds
        newCell.isAudioUsed = false
        newCell.isVideoUsed = false
        newCell.isUsed = false
        newCell.user_id = nil
        newCell .layoutIfNeeded();
        return newCell
    }
    
    //item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = 0.0
        var height = 0.0
        switch layoutType {
        case .LayoutTypeDefault:
            count = 1
            width = Double(GH_SCREENWIDTH!)
            height = Double(GH_SCREENHEIGH!)
            break
        case .LayoutTypeThreefourths:
            count = 2
            width = Double(GH_SCREENWIDTH!)
            height = Double(GH_SCREENHEIGH!)
            break
        case .LayoutTypeFourSplitScreen:
            count = 4
            width = Double((GH_SCREENWIDTH! - 5.0) / 2.0)
            height = Double((GH_SCREENHEIGH! - 5.0) / 2.0)
            break
        case .LayoutTypeSixSplitScreen:
            count = 6
            width = Double((GH_SCREENWIDTH! - 5.0) / 2.0)
            height = Double((GH_SCREENHEIGH! - 5.0) / 3.0)
            break
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
    //item 列间距(纵)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //item 列间距(纵)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //内容整体边距设置
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBOutlet weak var cameraBtn: FspButton!
    @IBOutlet weak var speakerBtn: FspButton!
    @IBOutlet weak var attendPeopleBtn: FspButton!
    @IBOutlet weak var messageBtn: FspButton!
    @IBOutlet weak var moreBtnid: FspButton!
    @IBOutlet weak var screenShareBtn: FspButton!
    @IBOutlet weak var micPhoneBtn: FspButton!
    
    @IBOutlet weak var subCellView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var needLayOutCollection: Bool = false
    //消息列表
    var sysTemVC:FspSystemMsgVC = FspSystemMsgVC()
    
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var lagLabel: UILabel!
    @IBOutlet weak var fspLabel: UILabel!
    @IBOutlet weak var cpuInfoLabel: UILabel!
    @IBOutlet weak var memryInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib.init(nibName: "FspCollectionViewCell", bundle: Bundle.main)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: FspViewCell)
        
        let tableViewCellNib = UINib.init(nibName: "FspListTableViewCell", bundle: Bundle.main)
        self.callBackTableList.register(tableViewCellNib, forCellReuseIdentifier: callViewCell)
        self.callBackTableList.separatorColor = .clear
        
        let atteedeeCellNib = UINib.init(nibName: "FspAttendeeCell", bundle: Bundle.main)
        self.attendeeTableView.register(atteedeeCellNib, forCellReuseIdentifier: attendeeViewCell)
        self.attendeeTableView.separatorColor = .clear
        
        
        let chooseSendUseIdNib = UINib.init(nibName: "FspMsgChooseSendCell", bundle: Bundle.main)
        self.chooseSendTableView.register(chooseSendUseIdNib, forCellReuseIdentifier: chooseSendUrsIdViewCell)
        self.chooseSendTableView.separatorColor = .clear
        
        
        
        self.subCellView.isHidden = true
        theApp.fspSignal.subscribeNext { (id) in
            let fspNum = id as! NSNumber
            DispatchQueue.main.async {
                let fspStr = "帧率: " + String(fspNum.intValue)
                self.fspLabel.text = fspStr
            }
        }
        
        theApp.lagsignal.subscribeNext { (id) in
            let isLag = (id as! NSNumber).boolValue
            var lagStr = ""
            if isLag == true
            {
                lagStr = "页面卡顿: true"
            }else
            {
                lagStr = "页面卡顿: false"
            }
            
            DispatchQueue.main.async {
                self.lagLabel.text = lagStr
            }
        }
        
        theApp.sysTemInfo.subscribeNext { (id) in

            let dict = id as! NSMutableDictionary
            let cpuUsage = (dict["cpuUsage"] as! NSNumber).intValue
            let memoryUsage = (dict["memoryUsage"] as! NSNumber).intValue
            let netWork = dict["netWorkType"] as! String
            DispatchQueue.main.async {
                let cpuStr = "CPU: " + String(cpuUsage)
                self.cpuInfoLabel.text = cpuStr
                let memNum = NSString.init(format: "%.02f", (Float(memoryUsage) / 1000000.0)) as String
                let memoryStr = "内存: " + memNum + " M"
                self.memryInfoLabel.text = memoryStr
                
                let netWorkStr = "网络类型: " + netWork
                self.networkLabel.text = netWorkStr
                
            }
            
        }
        
#if DEBUG
        self.cpuInfoLabel.isHidden = false
        self.networkLabel.isHidden = false
        self.memryInfoLabel.isHidden = false
        self.lagLabel.isHidden = false
        self.fspLabel.isHidden = false
#else
        self.cpuInfoLabel.isHidden = true
        self.networkLabel.isHidden = true
        self.memryInfoLabel.isHidden = true
        self.lagLabel.isHidden = true
        self.fspLabel.isHidden = true
#endif
        
        cameraBtn.setImage(UIImage(named: "摄像头 copy"), for: .normal)
        speakerBtn.setImage(UIImage(named: "扬声器 copy"), for: .normal)
        attendPeopleBtn.setImage(UIImage(named: "参会人 copy"), for: .normal)
        messageBtn.setImage(UIImage(named: "消息 copy"), for: .normal)
        moreBtnid.setImage(UIImage(named: "更多 copy"), for: .normal)
        screenShareBtn.setImage(UIImage(named: "屏幕 copy"), for: .normal)
        micPhoneBtn.setImage(UIImage(named: "语音 copy"), for: .normal)

        cameraBtn.setImage(UIImage(named: "摄像头"), for: .selected)
        speakerBtn.setImage(UIImage(named: "扬声器"), for: .selected)
        attendPeopleBtn.setImage(UIImage(named: "参会人"), for: .selected)
        messageBtn.setImage(UIImage(named: "消息"), for: .selected)
        moreBtnid.setImage(UIImage(named: "更多"), for: .selected)
        screenShareBtn.setImage(UIImage(named: "屏幕"), for: .selected)
        micPhoneBtn.setImage(UIImage(named: "语音"), for: .selected)


        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        self.view.addSubview(callingBackView)
        self.view.addSubview(self.attendeeView)
        self.view.addSubview(self.msgListView)
        
        
        
        self.msgListView.alpha = 0.0
        self.MessageListView .register(FspMsgCell.self, forCellReuseIdentifier: identifier)
        self.MessageListView.separatorColor = .clear
        
        self.view.addSubview(bottomView)
        //self.view.addSubview(self.chooseSendBgView)
        chooseSendTableBgView.layer.cornerRadius = 5
        
        self.bottomView.mas_makeConstraints { (make) in
            make?.height.mas_equalTo()(50)
            make?.left.equalTo()(self.view.mas_left)
            make?.right.equalTo()(self.view.mas_right)
            make?.bottom.equalTo()(self.view.mas_bottom)
        }
        
        self.view.addSubview(self.sysTemVC.view)
        self.sysTemVC.view.mas_makeConstraints { (make) in
            make?.height.mas_equalTo()(70)
            make?.width.mas_equalTo()(GH_SCREENWIDTH! / 2.0)
            make?.left.equalTo()(self.view.mas_left)
            make?.bottom.equalTo()(self.bottomView.mas_top)
        }
        
        
        self.isPublishingVideo = false
        self.isPublishingAudio = false
       // self.callingBackView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue1: 1.0, alpha: 0.98)
       // Do any additional setup after loading the view.
        
        self.msgListView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.bottomView.mas_top)?.offset()(0)
            make?.height.mas_equalTo()(529)
            make?.left.equalTo()(self.view.mas_left)
            make?.right.equalTo()(self.view.mas_right)
        }
        
        self.sendMsgButton.layer.cornerRadius = 20
        self.SendMsgBtn.layer.cornerRadius = 5
        self.SendMsgBtn.layer.borderColor = UIColor.init(red: 208.0/255, green: 215.0/255, blue: 233.0/255, alpha: 1.0).cgColor
        self.SendMsgBtn.layer.borderWidth = 1.0
        
        self.callingBackView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.bottomView.mas_top)?.offset()(0)
            make?.height.mas_equalTo()(529)
            make?.left.equalTo()(self.view.mas_left)
            make?.right.equalTo()(self.view.mas_right)
        }
        
        
        
        self.attendeeView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.bottomView.mas_top)?.offset()(0)
            make?.height.mas_equalTo()(529)
            make?.left.equalTo()(self.view.mas_left)
            make?.right.equalTo()(self.view.mas_right)
        }
        
        self.attendeeView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidEffected(tap:)))
        let msgTap = UITapGestureRecognizer(target: self, action: #selector(tapGestureDidEffected(tap:)))
        msgListView.addGestureRecognizer(msgTap)
        attendeeView.addGestureRecognizer(tap)
        
        //self.view.addGestureRecognizer(tap)

        //MARK: 一起来就选择的呼叫
        if fsp_manager.call_userIds.count > 0 {
            _ = fsp_manager.inviteUser(nUsersId: fsp_manager.call_userIds, nGroupId: fsp_manager.group_id!, nExtraMsg:"测试", nInviteId: inviteID)
            fsp_manager.call_userIds.removeAll()
        }
        
        
        //刷新在线列表
        self.refreshAttendTableViewWithModels(attendeeModels: fsp_manager.curGroupUsers)
        
        //加入会议开启组内成员信息和自己信息
        let attendeeInfo = FspAttendeeUsrInfo()
        attendeeInfo.is_videoOpen = false
        attendeeInfo.is_audioOpen = false
        attendeeInfo.video_id = ""
        attendeeInfo.user_id = fsp_manager.user_id!
       // autoLayOutAttendee.add(attendeeInfo)
        
 
        
       // print(autoLayOutAttendee.count)
        
        //更新选择模型数组
        let fspAllChooseModel = FspAllChooseModel()
        self.chooseSendBgViewArr.add(fspAllChooseModel)
        
        for usr in fsp_manager.curGroupUsers {
            let attendeeInfo = FspAttendeeUsrInfo()
            attendeeInfo.is_videoOpen = false
            attendeeInfo.is_audioOpen = false
            attendeeInfo.video_id = ""
            attendeeInfo.user_id = usr.useId
            if usr.useId == fsp_manager.user_id {
                continue
            }else{
                let curModel = FspChooseModel()
                curModel.userId = usr.useId
                self.chooseSendBgViewArr.add(curModel)
            }
            
            print(">>>>>>>>>>>>>>>>",usr.useId)
        }
        
        self.chooseSendTableView.reloadData()
        
    }
 
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.view.bounds.size.width,self.view.bounds.size.height)

        let isAutoCamera = UserDefaults.standard.object(forKey: isAutoOpenCamera) as? Bool
        let isAutoMic = UserDefaults.standard.object(forKey: isAutoOpenMicPhone) as? Bool
        if isAutoCamera == true {
            self.cameraBtnDidClick(self.cameraBtn)
        }
        if isAutoMic == true {
            self.audioBtnDidClick(self.micPhoneBtn)
        }

    }

    
    var edge_bottom: CGFloat = 0;
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            self.edge_bottom = self.view.safeAreaInsets.bottom
            self.bottomView.mas_updateConstraints { (make) in
                make?.height.mas_equalTo()(50 + self.edge_bottom)
            }
        } else {
            // Fallback on earlier versions
            self.edge_bottom = 0
        }
        
        //得到精确的frame
        //print(self.view.bounds.size.width,self.view.bounds.size.height)
    }
    
    var old_right: MASViewAttribute?
    var old_left: MASViewAttribute?
    var old_top: MASViewAttribute?
    var old_bottom: MASViewAttribute?
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            if #available(iOS 11.0, *) {
                return true
            } else {
                // Fallback on earlier versions
                return false
            }
        }set{
             //true
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        fsp_manager.keyBoardVC = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        fsp_manager.keyBoardVC = nil
    }
    

    //MARK:控制按钮事件
    @IBAction func audioBtnDidClick(_ sender: Any) {
        //FspTools.showAlert(msg: "用户ID不能为空!")
        micPhoneBtn.isSelected = !micPhoneBtn.isSelected
        isPublishingAudio = !isPublishingAudio
        let cell = self.getFreeCell(user_id: fsp_manager.user_id!, video_id: "")
        if isPublishingAudio == true {
            _ = fsp_manager.startPublishAudio()
            cell?.isAudioUsed = true
            cell?.user_id = fsp_manager.user_id
        }else{
            _ = fsp_manager.stopPublishAudio()
            cell?.isAudioUsed = false
            if cell?.isAudioUsed == false && cell?.isVideoUsed == false{
                cell?.user_id = nil
            }
        }
        let model = FspMessageModel()
        model.showMessageTime = true
        model.messageTime = FspTools.getCalendar()
        if micPhoneBtn.isSelected == true {
            //构建模型
            model.messageText = FspTools.createCustomModelStr(user_id: fsp_manager.user_id!, eventStr: fsp_tool_local_audio_open)
        }else{
            model.messageText = FspTools.createCustomModelStr(user_id: fsp_manager.user_id!, eventStr: fsp_tool_local_audio_close)
        }

        let attendeeModel = self.getAttendeeModelWithUrsId(userId: fsp_manager.user_id)
        if (attendeeModel != nil){
            attendeeModel!.isAudioOpen = isPublishingAudio
            self.updateAttendeeModelStatusWithModel(attendeeModel: attendeeModel!)
        }
        
        var localAudioDesc = ""
        if self.isPublishingAudio {
            localAudioDesc = fsp_manager.user_id! + "(我) 开始广播音频！"
        }else{
            localAudioDesc = fsp_manager.user_id! + "(我) 关闭视频！"
        }
        self.sysTemVC.refreashMsgSignal.sendNext(localAudioDesc)
    }
    
    @IBAction func cameraBtnDidClick(_ sender: Any) {
        //FspTools.showAlert(msg: "用户ID不能为空!")
        let model = FspMessageModel()
        model.showMessageTime = true
        model.messageTime = FspTools.getCalendar()
        cameraBtn.isSelected = !cameraBtn.isSelected
        let cell = self.getFreeCell(user_id: fsp_manager.user_id!, video_id: "")
        if cell != nil{
            
            if self.isPublishingVideo == true{
                cell!.LoginView.isHidden = false
                cell!.isVideoUsed = false
                print("####### fsp_manager == %@",fsp_manager)
                _ = fsp_manager.stopPublishVideo()
                self.isPublishingVideo = false
                cell?.user_id_label.text = ""
                cell?.renderView.isHidden = true
                if cell?.isAudioUsed == false && cell?.isVideoUsed == false{
                    cell?.user_id = nil
                }
                
                cell?.video_Id = ""
                count = count - 1
                
                //model.messageText = FspTools.createCustomModelStr(user_id: fsp_manager.user_id!, eventStr: fsp_tool_local_video_close)
            }else{
                cell!.LoginView.isHidden = true
                cell?.renderView.isHidden = false
                _ = fsp_manager.setVideoPreview(render: cell!.renderView)
                cell!.isVideoUsed = true
                _ = fsp_manager.startPublishVideo()
                self.isPublishingVideo = true
                cell?.user_id_label.text = "用户id:" + fsp_manager.user_id!
                cell?.user_id = fsp_manager.user_id
                count = count + 1
                cell?.video_Id = ""
                //model.messageText = FspTools.createCustomModelStr(user_id: fsp_manager.user_id!, eventStr: fsp_tool_local_video_open)
            }
            
        }else{
            model.messageText = "当前没有多余的展示窗口！"
        }
        
        var localVideoDesc = ""
        if self.isPublishingVideo {
            localVideoDesc = fsp_manager.user_id! + "(我) 开始广播视频！"
        }else{
            localVideoDesc = fsp_manager.user_id! + "(我) 关闭视频！"
        }
        self.sysTemVC.refreashMsgSignal.sendNext(localVideoDesc)
        
        let attendeeModel = self.getAttendeeModelWithUrsId(userId: fsp_manager.user_id)
        if (attendeeModel != nil){
            attendeeModel!.isCameraOpen = self.isPublishingVideo
            self.updateAttendeeModelStatusWithModel(attendeeModel: attendeeModel!)
        }
    }
    
    @IBAction func speakerBtnDidClick(_ sender: Any) {
        //FspTools.showAlert(msg: "用户ID不能为空!")
        speakerBtn.isSelected = !speakerBtn.isSelected
    }
    
    @IBAction func screenShareBtnDidClick(_ sender: Any) {
        let rect = self.screenShareBtn.frame
        let y = self.bottomView.frame
        let startPoint = CGPoint(x: rect.midX, y: y.midY - 35)
        self.popView.show(at: startPoint, popoverPostion: .up, withContentView: shareV, in: UIApplication.shared.keyWindow)
        self.popView.isUserInteractionEnabled = true
        screenShareBtn.isSelected = true
    }
    
    @IBAction func attendeeBtnDidClick(_ sender: Any) {
        //FspTools.showAlert(msg: "参会人列表暂时未提供!")
        attendPeopleBtn.isSelected = !attendPeopleBtn.isSelected
        
        let btn = sender as! UIButton
        btn.isSelected = true
        UIView.animate(withDuration: 0.5) {
            self.attendeeView.mas_updateConstraints { (make) in
                make?.top.equalTo()(self.bottomView.mas_top)?.offset()(-529)
            }
            self.attendeeView.alpha = 1.0
            self.bottomView.isUserInteractionEnabled = false
            self.collectionView.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func chatMessageViewBtnDidClick(_ sender: Any) {
        messageBtn.isSelected = false
        UIView.animate(withDuration: 0.25) {
            self.msgListView.mas_updateConstraints { (make) in
                make?.top.equalTo()(self.bottomView.mas_top)?.offset()(0)
            }
            self.msgListView.alpha = 0.0
            self.bottomView.isUserInteractionEnabled = true
            self.collectionView.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:选择消息发送人
    private(set) var chooseSendBgViewArr: NSMutableArray = NSMutableArray()
    @IBOutlet var chooseSendBgView: UIView!
    @IBOutlet weak var chooseSendTableBgView: UIView!
    @IBOutlet weak var chooseSendTableView: UITableView!
    @IBAction func hideChooseSendBgViewBtnDidClick(_ sender: Any) {
        self.hideChooseSendBg()
    }
    
    func hideChooseSendBg() -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            
            //view.transform = CGAffineTransformScale(view.transform,
                                                   // recognizer.scale, recognizer.scale)
            
            self.chooseSendBgView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.chooseSendBgView.alpha = 0
            
        }) { (finished) in
            let bgView = UIApplication.shared.keyWindow?.viewWithTag(2000)
            if bgView != nil {
                bgView?.removeFromSuperview()
                self.chooseSendBgView.removeFromSuperview()
            }else{
                bgView?.removeFromSuperview()
                self.chooseSendBgView.removeFromSuperview()
            }
            
        }
        
    }
    
    func showChooseSendBg() -> Void {
        let oldView = UIApplication.shared.keyWindow?.viewWithTag(2000)
        if oldView != nil {
            oldView?.removeFromSuperview()
        }
        
        let bgView = UIView.init(frame: UIApplication.shared.keyWindow!.bounds)
        bgView.tag = 2000
        bgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        bgView.addGestureRecognizer(tap)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        UIApplication.shared.keyWindow?.addSubview(self.chooseSendBgView)
        self.chooseSendBgView.mas_makeConstraints { (make) in
            make?.top.equalTo()(UIApplication.shared.keyWindow?.mas_top)?.offset()(0)
            make?.bottom.equalTo()(UIApplication.shared.keyWindow?.mas_bottom)?.offset()(0)
            make?.left.equalTo()(UIApplication.shared.keyWindow?.mas_left)?.offset()(0)
            make?.right.equalTo()(UIApplication.shared.keyWindow?.mas_right)?.offset()(0)
        }
        self.chooseSendBgView.alpha = 0
        self.chooseSendBgView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25) {
            self.chooseSendBgView.transform = CGAffineTransform.identity
            self.chooseSendBgView.alpha = 1
        }

    }
    
    @objc
    func hide() -> Void {
        self.hideChooseSendBg()
    }
    

    
    
    
    
    //MARK:参会人列表
    //参会人状态数组
    var attendeeStatusOnlineModel: NSMutableArray = NSMutableArray()
    
    @IBOutlet var attendeeView: UIView!
    
    @IBOutlet weak var attendeeTableView: UITableView!
    
    @IBOutlet weak var searchAttendeeField: UITextField!
    
    @IBAction func attendeeCloseBtnDidClick(_ sender: Any) {
        
        attendPeopleBtn.isSelected = !attendPeopleBtn.isSelected
        UIView.animate(withDuration: 0.25) {
            self.attendeeView.mas_updateConstraints { (make) in
                    make?.top.equalTo()(self.bottomView.mas_top)?.offset()(0)
            }
            
            self.attendeeView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        
        self.bottomView.isUserInteractionEnabled = true
        self.collectionView.isUserInteractionEnabled = true
        self.searchAttendeeField.resignFirstResponder()
    }
    
    func refreshAttendTableViewWithModels(attendeeModels: Array<FspAttendeeModel>) -> Void {
        for model in attendeeModels {
           attendeeStatusOnlineModel.add(model)
        }
        self.updateAttendeeTableViewOnMainThread()
    }
    
    //查找相应的在线列表模型
    func getAttendeeModelWithUrsId(userId: String!) -> FspAttendeeModel? {
        var attendeeModel: FspAttendeeModel?
        for model in attendeeStatusOnlineModel {
            if (model as! FspAttendeeModel).useId == userId{
                attendeeModel = (model as! FspAttendeeModel)
                break
            }
        }
        return attendeeModel
    }
    
    //更新参会人模型状态
    func updateAttendeeModelStatusWithModel(attendeeModel: FspAttendeeModel) -> Void {

        attendeeStatusOnlineModel.enumerateObjects { (obj, idx, objcBool) in
            let attendeeObj = obj as! FspAttendeeModel
            if attendeeModel.useId == attendeeObj.useId{
                attendeeObj.isAudioOpen = attendeeModel.isAudioOpen
                attendeeObj.isCameraOpen = attendeeModel.isCameraOpen
                attendeeObj.isScreenShareOpen = attendeeModel.isScreenShareOpen
                objcBool.pointee = true
            }
        }
        
        self.updateAttendeeTableViewOnMainThread()
    }
    
    //增加参会人模型
    func iecreaseAttendeeModelByUserId(userId: String) -> Void {
        let model = FspAttendeeModel()
        model.useId = userId
        attendeeStatusOnlineModel.add(model)
        self.updateAttendeeTableViewOnMainThread()
    }
    
    //删除参会人模型
    func decreaseAttendeeModelByUserId(userId: String) -> Void {
        attendeeStatusOnlineModel.enumerateObjects { (obj, idx, objcBool) in
            let attendeeObj = obj as! FspAttendeeModel
            if userId == attendeeObj.useId{
                attendeeStatusOnlineModel.remove(attendeeObj)
                objcBool.pointee = true
            }
        }
        
        self.updateAttendeeTableViewOnMainThread()
    }
    
    //更新列表
    func updateAttendeeTableViewOnMainThread() -> Void {
        if Thread.current == Thread.main {
            self.attendeeTableView.reloadData()
        }else{
            DispatchQueue.main.async {
                self.attendeeTableView.reloadData()
            }
        }
    }
    
    func updateSendMessageBtnTitleWithUsrId(userId: String) -> Void {
        DispatchQueue.main.async {
            let title = "发送给：" + userId
            self.SendMsgBtn.setTitle(title, for: .normal)
        }
        
    }
    
    //MARK:发送消息
    var messageModel: Array<FspMessageModel> = Array()
    @IBOutlet weak var MessageListView: UITableView!
    @IBOutlet var msgListView: UIView!
    @IBOutlet weak var inPutTextView: UITextView!
    @IBOutlet weak var SendMsgBtn: FspChooseSendMsgBtn!
    @IBOutlet weak var sendMsgButton: UIButton!
    
    @IBAction func chooseMsgUseBtnDidClick(_ sender: Any) {
        
        print("选择发送对象")
        self.showChooseSendBg()
    }
    
    let msgId = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
    
    enum CHOOSE_SEND_MSG_TYPE : Int {
        case CHOOSE_SEND_MSG_TYPE_GROUP = 0
        case CHOOSE_SEND_MSG_TYPE_SINGLE = 1
    }
    
    private(set) var defaultMsgSendType = CHOOSE_SEND_MSG_TYPE.init(rawValue: 0)
    private(set) var defaultMsgSendIndexModel = 0
    
    @IBAction func sendMsgBtnDidClick(_ sender: Any)
    {

        if self.inPutTextView.text.count == 0
        {
            FspTools.showAlert(msg: "消息不能为空!")
            return
        }
        
        let chatText = self.inPutTextView.textStorage.getPlainString()
        print(chatText)
        
        chooseSendBgViewArr.enumerateObjects { (obj, idx, objcBool) in
            let attendeeObj = obj as! FspMsgSendModel
            if attendeeObj.isChoosen == true
            {
                if idx == 0{
                    defaultMsgSendType = CHOOSE_SEND_MSG_TYPE.init(rawValue: 0)
                    defaultMsgSendIndexModel = 0
                }else{
                    //单消息
                    defaultMsgSendType = CHOOSE_SEND_MSG_TYPE.init(rawValue: 1)
                    defaultMsgSendIndexModel = idx
                }
                
                objcBool.pointee = true
            }
        }
        
        let curChooseModel = chooseSendBgViewArr[defaultMsgSendIndexModel] as! FspMsgSendModel
        var curUseChooseModelUserId = ""
        var curUseChooseModelUserIds: Array<String> = Array<String>()
        var msgModel: FspMessageModel?
        
        var status: FspErrCode = .FSP_ERR_FAIL
        if defaultMsgSendIndexModel == 0 {
            //群消息
            chooseSendBgViewArr.enumerateObjects { (obj, idx, objcBool) in
                let attendeeObj = obj as! FspMsgSendModel
                if idx != 0
                {
                    curUseChooseModelUserIds.append((attendeeObj as! FspChooseModel).userId)
                }
            
            }
            
            status = fsp_manager.sendGroupMsg(nMsg: chatText, nMsgId: msgId)
            
            msgModel = self.createModel(msgType: .ByUser, msgStr: chatText, userId: "所有人")
            
        }else{
            //单消息
            curUseChooseModelUserId = (curChooseModel as! FspChooseModel).userId
            status = fsp_manager.sendUsrMsg(nUserId: curUseChooseModelUserId, nMsg: chatText, nMsgId: msgId)
            
            msgModel = self.createModel(msgType: .ByUser, msgStr: chatText, userId: curUseChooseModelUserId)
        }

        if status == .FSP_ERR_OK
        {
            print("发送成功")
        }else{
            print("发送消息失败")
            return;
        }
        
        self.msgDataArr.add(msgModel)
        self.MessageListView.reloadData()
        
        self.inPutTextView.text = ""
        
        self.scrollToBottom()
    }
    
    func scrollToBottom() -> Void
    {
        
        DispatchQueue.main.async {
            var offsetY = 0.0
            for msgModel in self.msgDataArr {
                offsetY = offsetY + Double((msgModel as! FspMessageModel).cellHeight())
            }
            
            let height = Double(self.MessageListView.bounds.size.height)
            
            if offsetY < height {
                return
            }
            print(self.MessageListView.contentOffset.y)
            print("offsetY - height == %lf",offsetY - height)
            
            let index = IndexPath(row: self.msgDataArr.count - 1, section: 0)
            self.MessageListView.selectRow(at: index, animated: true, scrollPosition: .bottom)
        }
    }
    
    func createModel(msgType: FspMessageModelType!, msgStr: String!, userId: String!) -> FspMessageModel
    {
        let model = FspMessageModel()
        model.messageText = msgStr
        model.msgType = msgType
        model.showMessageTime = true
        let time = FspTools.getCalendar()
        var description = ""
        
        let color = UIColor.init(red: 106.0/255, green: 125.0/255, blue: 254.0/255, alpha: 1.0)
        
        
        if msgType == FspMessageModelType.ByUser
        {
             description = time + " " + "我对 " + userId + " " + "说: "
             let attributedString = NSMutableAttributedString(string: description)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : color], range: NSRange(location: time.count, length: 2))
            print(attributedString)
            
        }else
        {
             description = time + " " + userId + " " + "对我说: "
        }
        
        model.messageTime = description
        return model
    }
    
    @objc
    func textViewDidChangeText(noti: Notification) -> Void {}
    
    @IBAction func chatMessageBtn(_ sender: Any)
    {
       // FspTools.showAlert(msg: "聊天界面暂时未提供!")
        
        let btn = sender as! UIButton
        btn.isSelected = true
        UIView.animate(withDuration: 0.5) {
            self.msgListView.mas_updateConstraints { (make) in
                make?.top.equalTo()(self.bottomView.mas_top)?.offset()(-529)
            }
            self.msgListView.alpha = 1.0
            self.bottomView.isUserInteractionEnabled = false
            self.collectionView.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func moreBtnDidClick(_ sender: Any)
    {
        let rect = self.moreBtn.frame
        let y = self.bottomView.frame
        let startPoint = CGPoint(x: rect.midX, y: y.midY - 35)
        self.popView.show(at: startPoint, popoverPostion: .up, withContentView: moreV, in: UIApplication.shared.keyWindow)
        self.popView.isUserInteractionEnabled = true
        moreBtn.isSelected = true
    }
    
    lazy var fspMeetingSeetings: FspMeetingSettingViewController = {
        let fspMeetingSeetings = FspMeetingSettingViewController.init(nibName: "FspMeetingSettingViewController", bundle: Bundle.main)
        fspMeetingSeetings.loginOutBlock = { () -> () in
            DebugLogTool.debugLog(item: "fspMeetingSeetings 退出")
        }
        return fspMeetingSeetings
    }()
    /*
    var whiteBoardBlock: whiteBoardBlock?
    var sreenShareBlcok: sreenShareBlcok?
    var fileShareBlock: fileShareBlock?
    */
    lazy var shareV: shareMoreView = {
        let shareV = shareMoreView()
        shareV.frame = CGRect(x: 0, y: 0, width: 50, height: 150)
        shareV.backgroundColor = .clear
        shareV.isUserInteractionEnabled = true
        
        weak var weakSelf = self
        shareV.whiteBoardBlock = {() -> () in
            weakSelf!.popView.dismiss()
            DebugLogTool.debugLog(item: "电子白板点击")
            FspTools.showAlert(msg: "电子白板功能暂时未提供!")
            self.screenShareBtn.isSelected = false
        }
        
        shareV.fileShareBlock = {() -> () in
            weakSelf!.popView.dismiss()
            FspTools.showAlert(msg: "文件共享功能暂时未提供!")
            self.screenShareBtn.isSelected = false
            
        }
        
        shareV.sreenShareBlcok = {(isRecord) -> () in
            weakSelf!.popView.dismiss()
            FspTools.showAlert(msg: "屏幕共享功能暂时未提供!")
            self.screenShareBtn.isSelected = false
        }
        return shareV
    }()
    
    lazy var moreV: moreView = {
        let moreV = moreView()
        moreV.frame = CGRect(x: 0, y: 0, width: 50, height: 150)
        moreV.backgroundColor = .clear
        moreV.isUserInteractionEnabled = true
        
        weak var weakSelf = self
        moreV.callBlock = {() -> () in
            weakSelf!.popView.dismiss()
            weakSelf!.showCallingViewBtnDidClick()
        }
        
        moreV.settingBlock = {() -> () in
            weakSelf!.popView.dismiss()
            let view = UIViewController()
            weakSelf?.addChild(view)
            weakSelf?.addChild((weakSelf?.fspMeetingSeetings)!)
           //weakSelf?.view.addSubview((weakSelf?.fspMeetingSeetings.view)!)
           // weakSelf?.fspMeetingSeetings.willMove(toParent: weakSelf)
            weakSelf?.fspMeetingSeetings.view.frame = (weakSelf?.view.bounds)!
            weakSelf?.transition(from: view, to: (weakSelf?.fspMeetingSeetings)!, duration: 1, options: .transitionCurlUp, animations: {
                
            }, completion: { (finished) in
                weakSelf?.view.addSubview((weakSelf?.fspMeetingSeetings.view)!)
            })

        }
        
        moreV.recordBlcok = {(isRecord) -> () in
            weakSelf!.popView.dismiss()
            FspTools.showAlert(msg: "录制功能暂时未提供!")
        }
        
        return moreV
    }()
    
    lazy var popView: DXPopover = {
        let pop = DXPopover()
        weak var weakself = self
        pop.didDismissHandler = { () -> () in
            weakself?.moreBtn.isSelected = false
            weakself?.screenShareBtn.isSelected = false
        }
        pop.maskType = DXPopoverMaskType.none
        return pop
    }()
    
    @objc
    func hidePop() -> Void {
        self.popView.dismiss()
    }
    
    var layoutType: LayoutType = .LayoutTypeSixSplitScreen
    
    var Dcount:Int = 0
    var isPublishingVideo: Bool = false
    var isPublishingAudio: Bool = false
    
    @IBAction func changeLayOut(_ sender: Any) {
        
        Dcount = Dcount + 1
        if Dcount > 3 {
            Dcount = 0
        }
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        layoutType = LayoutType(rawValue: Int(Dcount))!
        self.collectionView.reloadData()
        let str = NSString.init(format: "当前是第%d个布局", Dcount)
        DebugLogTool.debugLog(item: str)
        
        collectionView.performBatchUpdates({
            
        }) { (isUpdate) in
            let cell = self.getFreeCell(user_id: fsp_manager.user_id!, video_id: "")
            if cell != nil{
                cell?.LoginView.isHidden = true
                fsp_manager.setVideoPreview(render: cell!.renderView)
                //cell!.isUsed = true
                cell?.user_id_label.text = "用户id:" + fsp_manager.user_id!
            }
            
        }
 
    }
    
    func getFreeCell(user_id: String,video_id: String) -> FspCollectionViewCell? {
        
        print(self.collectionView.visibleCells.count)
        
        for cell in self.collectionView.visibleCells{
            let res_cell = cell as! FspCollectionViewCell
            
            if video_id == ""{
                //本地视频或者本地音频
                if res_cell.user_id == user_id{
                    return res_cell
                }
            }else{
                //远端视频
                if res_cell.user_id ==  user_id && res_cell.video_Id == video_id {
                    return res_cell
                }
                
            }

        }
        
        
        for cell in self.collectionView.visibleCells {
            let res_cell = cell as! FspCollectionViewCell
            if res_cell.isVideoUsed == true || res_cell.isAudioUsed == true{
                //正在使用和当前useid不一样的音频或者视频
                continue
            }else{
                return res_cell
            }
        }
        
        return nil
    }
    
    //MARK:远端音频事件
    override func remoteAudioEvent(_ userId: String, eventType: FspRemoteAudioEventType) -> Void {
        
        let attendeeModel = self.getAttendeeModelWithUrsId(userId: userId)
        if (attendeeModel != nil){
            if eventType == .FSP_REMOTE_AUDIO_PUBLISH_STARTED{
                attendeeModel!.isAudioOpen = true
            }else if (eventType == .FSP_REMOTE_AUDIO_PUBLISH_STOPED){
                attendeeModel!.isAudioOpen = false
            }
            self.updateAttendeeModelStatusWithModel(attendeeModel: attendeeModel!)
        }
        
        var audioEventStr = ""
        if eventType == .FSP_REMOTE_AUDIO_PUBLISH_STARTED{
            audioEventStr = "用户: " + userId + "广播了音频！"
        }else if (eventType == .FSP_REMOTE_AUDIO_PUBLISH_STOPED){
            audioEventStr = "用户: " + userId + "关闭了音频！"
        }
        self.sysTemVC.refreashMsgSignal.sendNext(audioEventStr)
        
        DispatchQueue.main.async {
            
            let model = FspMessageModel()
            model.showMessageTime = true
            model.messageTime = FspTools.getCalendar()
            
            let cell = self.getFreeCell(user_id: userId,video_id: "")
            if cell == nil {
                print("没有空闲的cell")
                model.messageText = NSString(format: "当前没有空闲的窗口来展示用户id:%@", userId) as String
                self.msgDataArr.add(model)
                self.MessageListView.reloadData()
                return
            }
            
            if eventType == .FSP_REMOTE_AUDIO_PUBLISH_STARTED {
                //远端广播
                //远端增加
                DebugLogTool.debugLog(item: "增加音频")

                model.messageText = FspTools.createCustomModelStr(user_id: userId, eventStr: fsp_tool_remote_audio_open)
                
            }else if eventType == .FSP_REMOTE_AUDIO_PUBLISH_STOPED {
                //远端停止
                DebugLogTool.debugLog(item: "移除音频")
            
                model.messageText = FspTools.createCustomModelStr(user_id: userId, eventStr: fsp_tool_remote_audio_close)
            }
            
            //self.msgDataArr.add(model)
            self.MessageListView.reloadData()
        }
    }
    
    
    
    //MARK:远端视频事件
    override func remoteVideoEvent(_ userId: String, videoId: String, eventType: FspRemoteVideoEventType) -> Void{
        
        let attendeeModel = self.getAttendeeModelWithUrsId(userId: userId)
        if (attendeeModel != nil){
            if videoId == FSP_RESERVED_VIDEOID_SCREENSHARE {
            //桌面共享
                if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STARTED {
                   attendeeModel!.isScreenShareOpen = true
                }else if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STOPED{
                   attendeeModel!.isScreenShareOpen = false
                }
            }else{
            //视频
                if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STARTED {
                   attendeeModel!.isCameraOpen = true
                }else if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STOPED{
                   attendeeModel!.isCameraOpen = false
                }
            }
            self.updateAttendeeModelStatusWithModel(attendeeModel: attendeeModel!)
        }
        
        var videoEventStr = ""
        if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STARTED{
            videoEventStr = "用户: " + userId + "广播了视频！"
            if (videoId == FSP_RESERVED_VIDEOID_SCREENSHARE)
            {
                videoEventStr = "用户: " + userId + "广播了屏幕共享！"
            }
            self.sysTemVC.refreashMsgSignal.sendNext(videoEventStr)
        }else if (eventType == .FSP_REMOTE_VIDEO_PUBLISH_STOPED){
            videoEventStr = "用户: " + userId + "关闭了视频！"
            if (videoId == FSP_RESERVED_VIDEOID_SCREENSHARE)
            {
                videoEventStr = "用户: " + userId + "关闭了屏幕共享！"
            }
            self.sysTemVC.refreashMsgSignal.sendNext(videoEventStr)
        }
        
        DispatchQueue.main.async {
            
            let model = FspMessageModel()
            model.showMessageTime = true
            model.messageTime = FspTools.getCalendar()
            
            let cell = self.getFreeCell(user_id: userId,video_id: videoId)
            if cell == nil {
                print("没有空闲的cell")
                model.messageText = NSString(format: "当前没有空闲的窗口来展示用户id:%@", userId) as String
                self.msgDataArr.add(model)
                self.MessageListView.reloadData()
                return
            }
            
            if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STARTED {
                //远端广播
                //远端增加
                DebugLogTool.debugLog(item: "增加视频")
                fsp_manager.setRemoteVideoRender(userId: userId, videoId: videoId, render: cell!.renderView!, mode: .FSP_RENDERMODE_FIT_CENTER)
                cell?.user_id = userId
                cell?.isVideoUsed = true
                cell?.renderView.isHidden = false
                cell!.LoginView.isHidden = true
                cell!.video_Id = videoId
                model.messageText = FspTools.createCustomModelStr(user_id: userId, eventStr: fsp_tool_remote_video_open)
                
            }else if eventType == .FSP_REMOTE_VIDEO_PUBLISH_STOPED {
                //远端停止
                DebugLogTool.debugLog(item: "移除视频")
                fsp_manager.setRemoteVideoRender(userId: userId, videoId: videoId, render: nil, mode: .FSP_RENDERMODE_FIT_CENTER)
                cell?.user_id = nil
                cell?.isVideoUsed = false
                cell?.renderView.isHidden = true
                cell!.LoginView.isHidden = false
                cell!.video_Id = ""
                model.messageText = FspTools.createCustomModelStr(user_id: userId, eventStr: fsp_tool_remote_video_close)
                
                
            }else{
                //远端视频加载完成第一帧
                DebugLogTool.debugLog(item: "渲染视频第一帧")
                model.messageText =  NSString(format: "渲染视频第一帧 用户id:%@", userId) as String
            }
            
            //self.msgDataArr.add(model)
            self.MessageListView.reloadData()
            
        }
    }
 
    func showCallingViewBtnDidClick() -> Void {
        UIView.animate(withDuration: 0.5) {
            self.callingBackView.mas_updateConstraints { (make) in
                make?.top.equalTo()(self.bottomView.mas_top)?.offset()(-529)
            }
            self.callingBackView.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        
        self.bottomView.isUserInteractionEnabled = false
        self.collectionView.isUserInteractionEnabled = false
    }
    
    @IBAction func hideCallingViewBtnDidClick(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.callingBackView.mas_updateConstraints { (make) in
                self.callingBackView.mas_updateConstraints { (make) in
                    make?.top.equalTo()(self.bottomView.mas_top)?.offset()(0)
                }
            }
            
            self.callingBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        
        self.bottomView.isUserInteractionEnabled = true
        self.collectionView.isUserInteractionEnabled = true
        
        fsp_manager.call_userIds.removeAll()
    }
    
    func hideVC() -> Void {
        self.callingBackView.alpha = 0.0
    }
    
    //MARK:呼叫事件
    @IBAction func callMeetingBenDidClick(_ sender: Any) {
        DebugLogTool.debugLog(item: "邀请呼叫")
        self.startFspCallingRemoteUser()
    }
    
    var inviteID = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
    func startFspCallingRemoteUser() -> Void {
        var toUser_id = ""
        var userIDs = Array<String>()
        for model in self.listDataSourceArr {
            let NewModel = model as! listStatusModel
            if NewModel.is_selected == true{
                userIDs.append(NewModel.user_id)
            }
        }
        
        if userIDs.count == 0 {
            FspTools.showAlert(msg: "邀请与会人员未选择！")
            return
        }

        var callRemoteUsr = "我向用户 "
        for user_id in userIDs{
            toUser_id = toUser_id + (user_id as! String) + ","
            callRemoteUsr += user_id + " ";
        }
        callRemoteUsr += "发送与会邀请！"
        self.sysTemVC.refreashMsgSignal.sendNext(callRemoteUsr)
        
        
        fsp_manager.inviteUser(nUsersId: userIDs, nGroupId: fsp_manager.group_id!, nExtraMsg: "测试", nInviteId: inviteID)
        let model = FspMessageModel()
        model.showMessageTime = true
        model.messageTime = FspTools.getCalendar()
        model.messageText = FspTools.createInvitationModelStr(user_id: fsp_manager.user_id!, toUser_id: toUser_id, inviteID: Int(inviteID.pointee), eventStr: fsp_tool_invitation_open)
        self.runSynMessageModelUpdate(messageBlock: { (model) in
            
        }, model: model)
        
    }
    
    //MARK:在线人员记录
    var lock = NSLock()
    override func updateListTableView(dataSourceArr: NSMutableArray) -> Void {
        lock.lock()
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
            self.callBackTableList.reloadData()
        }
        lock.unlock()
    }
    

    @IBOutlet weak var imageChooseIcon: UIImageView!
    @IBAction func allModelSelectedBtnDidClick(_ sender: Any) {
        
        lock.lock()
        if self.listDataSourceArr.count == 0 {
            return
        }
        
        if self.imageChooseIcon.isHighlighted == false {
            self.imageChooseIcon.isHighlighted = true
            DebugLogTool.debugLog(item: "全选")
            for model in self.listDataSourceArr {
                let newModel = model as! listStatusModel
                newModel.is_selected = true
            }
        }else{
            self.imageChooseIcon.isHighlighted = false
            DebugLogTool.debugLog(item: "全不选")
            for model in self.listDataSourceArr {
                let newModel = model as! listStatusModel
                newModel.is_selected = false
            }
        }
        
        self.callBackTableList.reloadData()
        lock.unlock()
    }
    
    
    //MARK:消息记录
    override func runSynMessageUpdate(messageBlock: () -> ()) {
        //更新消息
        DebugLogTool.debugLog(item: "更新消息列表")
        DispatchQueue.main.async {
            self.MessageListView.reloadData()
        }
    }
    
    
    override func runSynMessageModelUpdate(messageBlock: (FspMessageModel) -> (), model: FspMessageModel) {
        //更新数据模型数据
        DebugLogTool.debugLog(item: "更新消息列表模型")
        msgDataArr.add(model)
        self.runSynMessageUpdate {
            
        }
    }
 
    
    
    //MARK:信息列表
    
    override func boardWillHideUp(noti: NSNotification) {
        print("FspMeetingViewController hide")
        UIView.animate(withDuration: 0.25) {
            self.msgListView.mas_updateConstraints { (make) in
                make?.top.equalTo()(self.bottomView.mas_top)?.offset()(-529)
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func boardWillShowUp(noti: NSNotification) {
        print("FspMeetingViewController show")
        let userInfo = noti.userInfo
        let value = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyBoardRect = value.cgRectValue
        let deltaY = keyBoardRect.origin.y
        let bottonY = self.bottomView.frame.origin.y
        let offsetY = bottonY - deltaY
        UIView.animate(withDuration: 0.5) {
            self.msgListView.mas_updateConstraints { (make) in
                make?.top.equalTo()(self.bottomView.mas_top)?.offset()(-offsetY - 529)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func tapGestureDidEffected(tap: UITapGestureRecognizer) -> Void {
        if self.inPutTextView.isFirstResponder {
            self.inPutTextView.resignFirstResponder()
        }
        
        if self.searchAttendeeField.isFirstResponder {
            self.searchAttendeeField.resignFirstResponder()
        }
    }
    
    override func onReceiveUserMsg(_ nSrcUserId: String, msg nMsg: String, msgId nMsgId: Int32) -> Void {
        
        print("收到用户信息")
        let model = self.createModel(msgType: .ByRemoteUser, msgStr: nMsg, userId: nSrcUserId)
        
        //刷新列表
        self.runSynMessageModelUpdate(messageBlock: { (model) in
            
        }, model: model)
        
        
        self.scrollToBottom()
    }
    
    override func onReceiveGroupMsg(_ nSrcUserId: String, msg nMsg: String, msgId nMsgId: Int32) -> Void {
        
        print(nSrcUserId)
        print("收到群消息")
        let model = self.createModel(msgType: .ByRemoteUser, msgStr: nMsg, userId: nSrcUserId)
        
        //刷新列表
        self.runSynMessageModelUpdate(messageBlock: { (model) in
            
        }, model: model)
        
        
        self.scrollToBottom()
        
    }
    
    override func onGroupUsersRefreshed(userIds: Array<String>) {
        
        print("收到群列表")
        
    }
    
    override func onGroupUserJoined(userId: String) {
        print(userId + "加入组")
        self.iecreaseAttendeeModelByUserId(userId: userId)
        
        let fspchooseModel = FspChooseModel()
        fspchooseModel.userId = userId
        fspchooseModel.isChoosen = false
        self.chooseSendBgViewArr.add(fspchooseModel)
        
        self.refreshChooseSendTableViewOnMainThread()
        
        
        let attendeeInfo = FspAttendeeUsrInfo()
        attendeeInfo.is_videoOpen = false
        attendeeInfo.is_audioOpen = false
        attendeeInfo.video_id = ""
        attendeeInfo.user_id = userId
        
        let des = "用户: " + userId + "进入会议室！"
        self.sysTemVC.refreashMsgSignal.sendNext(des)
        
    }
    
    override func onGroupUserLeaved(userId: String) {
        print(userId + "离开组")
        
        let des = "用户: " + userId + "离开会议室！"
        self.sysTemVC.refreashMsgSignal.sendNext(des)

        self.decreaseAttendeeModelByUserId(userId: userId)
        
        var isChooseLeave = false
        if chooseSendBgViewArr.count > 0 {
            chooseSendBgViewArr.enumerateObjects { (obj, idx, objcBool) in
                
                if idx != 0{
                    let attendeeObj = obj as! FspChooseModel
                    if userId == attendeeObj.userId{
                        chooseSendBgViewArr.remove(attendeeObj)
                        objcBool.pointee = true
                        isChooseLeave = true
                    }
                }
            }
        }
        
        //选中的离开群组了，默认选择发送所有人
        var userId = ""
        
        if isChooseLeave == true {
            chooseSendBgViewArr.enumerateObjects { (obj, idx, objcBool) in
                if idx == 0 {
                    
                    let attendeeObj = obj as! FspAllChooseModel
                    attendeeObj.isChoosen = true
                    userId = "所有人"
                    
                } else
                {
                    let attendeeObj = obj as! FspChooseModel
                    attendeeObj.isChoosen = false
                    userId = attendeeObj.userId
                }
                
            }
        }
  
       self.updateSendMessageBtnTitleWithUsrId(userId: userId)
       self.refreshChooseSendTableViewOnMainThread()
  

    }
    
    func refreshChooseSendTableViewOnMainThread() -> Void {
        if Thread.current == Thread.main{
            self.chooseSendTableView.reloadData()
        }else{
            DispatchQueue.main.sync {
                self.chooseSendTableView.reloadData()
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
