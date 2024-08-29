//
//  MessageCell.swift
//  firebase_registration
//
//  Created by Yusata Infotech Pvt Ltd on 14/08/24.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
