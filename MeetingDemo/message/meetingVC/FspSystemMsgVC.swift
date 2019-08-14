//
//  FspSystemMsgVC.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/7/25.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit
import ReactiveObjC

let fspSystemCell = "FSP_SYSTEM_CELL"

let welcomeStr = "系统消息: 欢迎来到好视通演示Demo!"
let UsrJoinMeetingStr = "系统消息: 用户id 加入会议组！"
let UsrLeaveMeetingStr = "系统消息: 用户id 离开会议组！"
let UsrBroadCastAudioStr = "系统消息: 用户id 广播了音频！"
let UsrBroadCastVideoStr = "系统消息: 用户id 广播了视频！"
let UsrStopBroadCastVideoStr = "系统消息: 用户id 关闭视频！"
let UsrStopBroadCastAudioStr = "系统消息: 用户id 关闭音频！"

class FspSystemMsgVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if msgInfoArr.count > 0 {
            return msgInfoArr.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: fspSystemCell, for: indexPath) as! FspSysTemTableViewCell
        cell.selectionStyle = .none
        let str = msgInfoArr[indexPath.row] as! String
        cell.descritionstr = str
        cell.descritionLabel.text = str
        cell.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = msgInfoArr[indexPath.row] as! String
        let size = self.labelAutoCalculateRectWith(text: str, textFont: UIFont.init(name: FONT_REGULAR, size: 10)!, maxSize: CGSize(width: CGFloat(GH_SCREENWIDTH! / 2.0), height: CGFloat(MAXFLOAT)))
        return size.height;
    }
    
    func labelAutoCalculateRectWith(text: String, textFont: UIFont, maxSize: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font : textFont]
        let rect = (text as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size
    }
    
    @IBOutlet weak var fspSystemTable: UITableView!
    var refreashMsgSignal: RACSubject =  RACSubject()
    var msgInfoArr = NSMutableArray()
    
    var msgMonitor: Timer?
    
    @objc
    func updateMsgInfoAlpha() -> Void {
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0.0
        }
    }
    
    deinit {
        if self.msgMonitor != nil {
            msgMonitor!.invalidate()
            msgMonitor = nil
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let chooseRresetTableViewNib = UINib.init(nibName: "FspSysTemTableViewCell", bundle: Bundle.main)
        self.fspSystemTable.register(chooseRresetTableViewNib, forCellReuseIdentifier: fspSystemCell)
        self.fspSystemTable.separatorColor = .clear
   
        self.view.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        self.fspSystemTable.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        
        msgInfoArr.add(welcomeStr)
        
        refreashMsgSignal.subscribeNext { (obj) in
            let MsgInfo = obj as! String
            print("################",MsgInfo)
            self.msgInfoArr.add(MsgInfo)
            if (Thread.isMainThread){
                
                self.view.alpha = 1.0
                if self.msgMonitor != nil{
                    self.msgMonitor!.invalidate()
                }
                self.msgMonitor = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateMsgInfoAlpha), userInfo: nil, repeats: false)
                self.fspSystemTable.reloadData()
            }else{
                DispatchQueue.main.sync {
                    self.view.alpha = 1.0
                    if self.msgMonitor != nil{
                        self.msgMonitor!.invalidate()
                    }
                    self.msgMonitor = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateMsgInfoAlpha), userInfo: nil, repeats: false)
                   self.fspSystemTable.reloadData()
                }
            }
            
            self.scrollToBottom()
        }
        
        msgMonitor = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateMsgInfoAlpha), userInfo: nil, repeats: false)
        self.fspSystemTable.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func scrollToBottom() -> Void
    {
        
        DispatchQueue.main.async {
            var offsetY = 0.0
            for msgModel in self.msgInfoArr {
                let strInfo = msgModel as! String
                let size = self.labelAutoCalculateRectWith(text: strInfo, textFont: UIFont.init(name: FONT_REGULAR, size: 10)!, maxSize: CGSize(width: CGFloat(GH_SCREENWIDTH! / 2.0), height: CGFloat(MAXFLOAT)))
                let height = size.height;
                offsetY = offsetY + Double(height)
            }
            
            let height = Double(self.fspSystemTable.bounds.size.height)
            
            if offsetY < height {
                return
            }
            print(self.fspSystemTable.contentOffset.y)
            print("offsetY - height == %lf",offsetY - height)
            
            let index = IndexPath(row: self.msgInfoArr.count - 1, section: 0)
            self.fspSystemTable.selectRow(at: index, animated: true, scrollPosition: .bottom)
        }
    }

    func updateTable() -> Void {
        
        
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
