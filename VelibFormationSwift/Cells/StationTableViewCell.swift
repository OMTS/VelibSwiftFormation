//
//  StationTableViewCell.swift
//  VelibFormationSwift
//
//  Created by Iman Zarrabian on 19/01/15.
//  Copyright (c) 2015 Iman Zarrabian. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var addressLabel : UILabel!
    @IBOutlet var avatarView : UIImageView!
    @IBOutlet var favView : UIView!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.avatarView.layer.masksToBounds {
            self.avatarView.layer.cornerRadius = 15.0
            self.avatarView.layer.masksToBounds = true
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
