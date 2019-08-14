//
//  FspAttendeeCell.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/29.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

class FspAttendeeCell: UITableViewCell {

    
    private var _isAudioOpen = false
    var isAudioOpen: Bool{
        set{
            _isAudioOpen = newValue
            self.changeBtnSelectedStatus(btn: attendee_audio_btn, isSelected: _isAudioOpen)
        }get{
            return _isAudioOpen
        }
    }
    
    private var _isScreenShareOpen = false
    var isScreenShareOpen: Bool{
        set{
            _isScreenShareOpen = newValue
            self.changeBtnSelectedStatus(btn: attendee_screen_share_btn, isSelected: _isScreenShareOpen)
        }get{
            return _isScreenShareOpen
        }
    }
    
    private var _isCameraOpen = false
    var isCameraOpen: Bool{
        set{
            _isCameraOpen = newValue
            self.changeBtnSelectedStatus(btn: attendee_camera_btn, isSelected: _isCameraOpen)
        }get{
            return _isCameraOpen
        }
    }
    
    func changeBtnSelectedStatus(btn: UIButton, isSelected: Bool) -> Void {
        DispatchQueue.main.async {
            btn.isSelected = isSelected
            self.layoutIfNeeded()
        }
        
    }
    

    @IBOutlet weak var attendee_userid_textFiled: UILabel!
    @IBOutlet weak var attendee_audio_btn: UIButton!
    @IBOutlet weak var attendee_camera_btn: UIButton!
    @IBOutlet weak var attendee_screen_share_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func attendee_audio_btn_clicked(_ sender: Any) {
       print("audio")
    }
    
    @IBAction func attendee_camera_btn_clicked(_ sender: Any) {
        print("camra")
    }
    
    @IBAction func attendee_screen_share_btn_clicked(_ sender: Any) {
        print("screen share")
    }
    
    
}
