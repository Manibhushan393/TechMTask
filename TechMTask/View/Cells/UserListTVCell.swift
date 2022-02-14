//
//  UserListTVCell.swift
//  TechMTask
//
//  Created by Mani bhushan M on 14/02/22.
//

import UIKit

class UserListTVCell: UITableViewCell {

    @IBOutlet weak var userAvathar : UIImageView!
    @IBOutlet weak var userNameLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
