//
//  UserEntryTableViewCell.swift
//  SimpleAddressBook
//
//  Created by Cleofas Villarin on 3/8/17.
//  Copyright © 2017 Cleofas Villarin. All rights reserved.
//

import UIKit

class UserEntryTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phonenumberLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
