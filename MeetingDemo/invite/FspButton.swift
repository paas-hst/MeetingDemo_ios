//
//  FspButton.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/26.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

class FspButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = .center
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX = 0.0
        let titleY = contentRect.size.height * 0.7
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRect(x: CGFloat(titleX), y: titleY, width: titleW, height: titleH)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width
        let imageH = contentRect.size.height * 0.7
        return CGRect(x: 0.0, y: 0.0, width: imageW, height: imageH)
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
