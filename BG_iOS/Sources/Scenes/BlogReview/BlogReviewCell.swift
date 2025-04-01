//
//  BlogReviewCell.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/06.
//

import UIKit

class BlogReviewCell: UITableViewCell {

    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var blogContentLabel: UILabel!
    @IBOutlet weak var blogNameLabel: UILabel!
    @IBOutlet weak var blogDateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    func setupUI() {
        // 그림자 설정
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 5
       
       // cornerRadius 설정
       containerView.layer.cornerRadius = 10
       containerView.clipsToBounds = true
    }

}
