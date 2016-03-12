//
//  SPStoreCell.swift
//  Shopping
//
//  Created by 胡 帅 on 15/11/29.
//  Copyright © 2015年 Disney. All rights reserved.
//

import UIKit

class SPStoreCell: UITableViewCell {
    @IBOutlet weak var lblNear: UILabel!
    @IBOutlet weak var lblLoc: UILabel!
    @IBOutlet weak var lblZip: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
