//
//  ItemSelectCell.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/08.
//

import UIKit

class ItemSelectCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
