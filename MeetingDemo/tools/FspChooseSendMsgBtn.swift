//
//  FspChooseSendMsgBtn.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/21.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

class FspChooseSendMsgBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.textAlignment = .left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = .left
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX = 10.0
        let titleY = (contentRect.size.height - 20.0 ) / 2.0
        let titleW = contentRect.size.width  * 0.7
        let titleH = 20.0
        return CGRect(x: CGFloat(titleX), y: titleY, width: titleW, height: CGFloat(titleH))
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        //let imageW = contentRect.size.width  * 0.3
        //let imageH = contentRect.size.height
        return CGRect(x: contentRect.size.width - 9 - 5, y: (contentRect.size.height - 9.0) / 2.0, width: 9, height: 9)
    }

}
