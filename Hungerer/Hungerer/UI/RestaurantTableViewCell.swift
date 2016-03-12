//
//  RestaurantTableViewCell.swift
//  Hungerer
//
//  Created by 胡 帅 on 15/5/21.
//  Copyright (c) 2015年 none. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var brandImageView:UIImageView?
    @IBOutlet weak var nameLabel:UILabel?
    @IBOutlet weak var cityLabel:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
