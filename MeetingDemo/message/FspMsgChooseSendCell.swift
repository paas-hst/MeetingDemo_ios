//
//  FspMsgChooseSendCell.swift
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/30.
//  Copyright © 2019 hst. All rights reserved.
//

import UIKit

class FspMsgChooseSendCell: UITableViewCell {

    @IBOutlet weak var uerIdLabel: UILabel!
    @IBOutlet weak var isChoosen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
