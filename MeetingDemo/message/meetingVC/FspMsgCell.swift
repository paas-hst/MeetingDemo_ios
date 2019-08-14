//
//  FspMsgCell.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/4/4.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

let identifier = "WeChatCell"


class FspMsgCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var _messageModel: FspMessageModel?
    var messageModel: FspMessageModel? {
        get{
            return _messageModel
        }set{
            _messageModel = newValue
            timeLabel?.isHidden = !_messageModel!.showMessageTime
            timeLabel?.frame = _messageModel!.timeFrame()
            timeLabel?.text = _messageModel!.messageTime
            timeLabel?.backgroundColor = .clear
            timeLabel?.textColor = .black
            
            bubbleImageView?.isHidden = false
            let rect = _messageModel!.messageFrame()
            bubbleImageView?.frame = CGRect(x: rect.origin.x - 10, y: rect.origin.y - 5, width: rect.width + 10, height: rect.height + 15)
            //bubbleImageView?.backgroundColor = color
            bubbleImageView?.layer.cornerRadius = 5
            if _messageModel?.msgType == FspMessageModelType.ByUser {
    
                messageLabel?.textColor = .black
                bubbleImageView?.backgroundColor = .white
                self.addShadow(view: bubbleImageView!, theColor: orangeColor)
            }else{
                
                
                messageLabel?.textColor = .white
                bubbleImageView?.backgroundColor = color
                self.addShadow(view: bubbleImageView!, theColor: color)
            }

            
            messageLabel?.isHidden = false
            messageLabel?.frame = _messageModel!.messageFrame()
            messageLabel?.text = messageModel!.messageText
            messageLabel?.textAlignment = .left
            
            messageLabel?.backgroundColor = .clear
                //UIColor.init(red: 106.0/255, green: 125.0/255, blue: 254.0/255, alpha: 1.0)
            
            //106 125 254
        }
    }
    
    let color = UIColor.init(red: 106.0/255, green: 125.0/255, blue: 254.0/255, alpha: 1.0)
    let orangeColor = UIColor.init(red: 248.0/255, green: 209.0/255, blue: 174.0/255, alpha: 1.0)
    
    
    func addShadow(view: UIView, theColor: UIColor) -> Void {
        view.layer.shadowColor = theColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        
    }
    
   public class func cellWithTableView(tableView: UITableView,messageModel: FspMessageModel) -> FspMsgCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? FspMsgCell
        if cell == nil {
            cell = FspMsgCell(style: .default, reuseIdentifier: identifier) as FspMsgCell
        }
        cell!.messageModel = messageModel
        
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.createSubViewTime()
        self.creatSubViewBubble()
        self.creatSubViewMessage()
        
        self.backgroundColor = UIColor.init(red: 251.0/255, green: 252.0/255, blue: 255.0/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    var timeLabel: UILabel?
    //MARK:初始化subviews
    func createSubViewTime() -> Void {
        timeLabel = UILabel()
        timeLabel?.isHidden = true
        self.contentView.addSubview(timeLabel!)
        timeLabel?.font = UIFont.init(name: FONT_REGULAR, size: 10)
        timeLabel?.backgroundColor = .clear
        timeLabel?.textColor = .black
        timeLabel?.textAlignment = .center
        textLabel?.layer.masksToBounds = true
        textLabel?.layer.cornerRadius = 4
    }
    
    var messageLabel: UILabel?
    func creatSubViewMessage() -> Void {
        messageLabel = UILabel()
        messageLabel?.isHidden = true
        self.contentView.addSubview(messageLabel!)
        messageLabel?.font = UIFont.init(name: FONT_REGULAR, size: 12)
        messageLabel?.numberOfLines = 0
        messageLabel?.lineBreakMode = .byWordWrapping
        messageLabel?.textColor = .black
    }
    
    var bubbleImageView: UIView?
    func creatSubViewBubble() -> Void {
        bubbleImageView = UIView()
        bubbleImageView?.isHidden = true
        self.contentView.addSubview(bubbleImageView!)
        bubbleImageView?.isUserInteractionEnabled = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressBubbleView(longTap:)))
       // bubbleImageView?.addGestureRecognizer(longPressGesture)

    }
    
    @objc
    func longPressBubbleView(longTap: UILongPressGestureRecognizer) -> Void {
        if longTap.state == UIGestureRecognizer.State.began {
            self.showMenuControllerInView(inView: self, subView: longTap.view!)
        }
        
    }
    
    @objc
    func copyTextSender(sender: Any) -> Void {
        let pasteBoard = UIPasteboard.general
        if (self.messageModel?.messageText?.count)! > 0 {
            pasteBoard.string = self.messageModel?.messageText
        }
        
    }
    
    func showMenuControllerInView(inView: FspMsgCell, subView: UIView) -> Void {
        self.becomeFirstResponder()
        
        let copyText = UIMenuItem(title: "复制", action: #selector(copyTextSender(sender:)))
        let menu = UIMenuController.shared
        print(menu)
        menu.setTargetRect(self.bounds, in: self)
        menu.arrowDirection = .default
        menu.menuItems = [copyText]
        menu.isMenuVisible = true
        
    }
    
    
    
}
