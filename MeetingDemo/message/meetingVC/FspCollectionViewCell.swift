//
//  FspCollectionViewCell.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/28.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

protocol FspCollectionViewCellDelegate {
    func cellDoubleTap(sender: UITapGestureRecognizer)
    func cellSingleTap(sender: UITapGestureRecognizer)
}
class FspCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var renderView: UIView!
    @IBOutlet weak var LoginView: UIImageView!
    @IBOutlet weak var user_id_label: UILabel!
    
    var delegate : FspCollectionViewCellDelegate?
    var originFrame : CGRect?
    var isFullScreen = false
    var user_id: String?
    var video_Id: String?
    
    
    var isAudioUsed = false
    var isVideoUsed = false
    
    var isUsed = false
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //DebugLogTool.debugLog(item: "FspCollectionViewCell awake")

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTap(sender:)))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
        tap.require(toFail: doubleTap)
        
        video_Id = ""
    }

    @objc
    func doubleTap(sender: UITapGestureRecognizer) -> Void {
        if self.delegate != nil {
            self.delegate?.cellDoubleTap(sender: sender)
        }
    }
    
    @objc
    func singleTap(sender: UITapGestureRecognizer) -> Void {
        if self.delegate != nil {
            self.delegate?.cellSingleTap(sender: sender)
        }
    }
}
