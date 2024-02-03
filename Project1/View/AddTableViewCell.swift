//
//  AddTableViewCell.swift
//  Project1
//
//  Created by Karthiga K on 03/02/24.
//

import UIKit

class AddTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var txtAddName: UITextField!
    @IBOutlet weak var txtAddEmail: UITextField!
    @IBOutlet weak var txtAddGender: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
