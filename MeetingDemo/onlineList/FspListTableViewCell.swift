//
//  FspListTableViewCell.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/27.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit

class FspListTableViewCell: UITableViewCell {

    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var choseImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
