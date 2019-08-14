//
//  FspMessageModel.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/4/4.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHight = UIScreen.main.bounds.size.height
let FONT_REGULAR  = "PingFangSC-Regular"

enum FspMessageModelType {
    case ByUser
    case ByRemoteUser
}

class FspMessageModel: NSObject {

    var messageText: String?
    var messageTime: String?
    var showMessageTime: Bool = true
    var msgType: FspMessageModelType!
    

    override init() {
        super.init()
        messageText = ""
        messageTime = ""
        //自己
        msgType = .ByUser
    }
    
    //时间cell大小
    func timeFrame() -> CGRect {
        var rect = CGRect.zero
        
        if self.showMessageTime {
            let size = self.labelAutoCalculateRectWith(text: self.messageTime!, textFont: UIFont.init(name: FONT_REGULAR, size: 10)!, maxSize: CGSize(width: CGFloat(MAXFLOAT), height: 17))
            if msgType == .ByUser{
                rect = CGRect(x: ScreenWidth - size.width - 10.0, y: 0, width: size.width + 10.0, height: 17.0)
            }else{
                rect = CGRect(x: 0.0, y: 0, width: size.width + 10.0, height: 17.0)
            }
            
        }
        return rect
    }
    

    //消息cell大小
    func messageFrame() -> CGRect {
        let timeRect = self.timeFrame()
        var rect = CGRect.zero
        let maxWidth = ScreenWidth * 0.7 //- 60
        let size = self.labelAutoCalculateRectWith(text: self.messageText!, textFont: UIFont.init(name: FONT_REGULAR, size: 12)!, maxSize: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)))
        if self.messageText?.count == 0 {
            return rect
        }
        
        
        if msgType == .ByRemoteUser {
            //自己的消息
            rect = CGRect(x: ScreenWidth * 0.1, y: timeRect.size.height + 10, width: maxWidth - 5.0, height: size.height > 44.0 ? size.height : 44.0)
        }else{
            //远端消息
            rect = CGRect(x: 65, y: timeRect.size.height + 10, width: maxWidth, height: size.height > 44.0 ? size.height : 44.0)
        }
        return rect
    }
    
    //气泡cell大小
    func bubbleFrame() -> CGRect {
        var rect = CGRect.zero
        rect = self.messageFrame()
        rect.origin.x = rect.origin.x - 10
        rect.size.width = rect.size.width + 25.0
        rect.origin.y = rect.origin.y - 10
        rect.size.height = rect.size.height + 10
        return rect
    }
    
    //返回cell高度
    func cellHeight() -> CGFloat {
        return self.timeFrame().size.height + self.messageFrame().size.height + self.messageFrame().origin.y - self.timeFrame().origin.y + 10
    }
    
    func labelAutoCalculateRectWith(text: String, textFont: UIFont, maxSize: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font : textFont]
        let rect = (text as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size
    }
    
    
}
