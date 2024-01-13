//
//  ItemSelectCell.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/08.
//

import UIKit

class ItemSelectCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
