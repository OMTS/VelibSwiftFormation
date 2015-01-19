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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    
    func configureView() {
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
