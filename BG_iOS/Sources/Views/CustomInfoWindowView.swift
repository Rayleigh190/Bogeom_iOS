//
//  CustomInfoWindowView.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/10.
//

import NMapsMap

class CustomInfoWindowView: NSObject, NMFOverlayImageDataSource {
    enum Status {
        case selected
        case normal
    }
  
    var status: Status
    
    let shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    let shopAddressLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        return label
    }()
    let updatedAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
  
    init(shopName: String, shopAddress: String, itemPrice: String, updatedAt: String, status: Status = .normal) {
        self.shopNameLabel.text = shopName
        self.shopAddressLabel.text = shopAddress
        self.itemPriceLabel.text = itemPrice
        self.updatedAtLabel.text = updatedAt
        self.status = status
    }
  
    func view(with overlay: NMFOverlay) -> UIView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing
            [shopNameLabel, shopAddressLabel, itemPriceLabel, updatedAtLabel].forEach { stackView.addArrangedSubview($0) }
            let shopAddressLabelSize = shopAddressLabel.intrinsicContentSize

            stackView.frame = CGRect(x: 0, y: 0, width: shopAddressLabelSize.width, height: shopAddressLabelSize.height*4)
            
            stackView.layer.cornerRadius = 10
            stackView.layer.borderWidth = 0.5
            stackView.layer.borderColor = UIColor.black.cgColor
            stackView.clipsToBounds = true

            if status == .normal {
                stackView.backgroundColor = .white
            } else {
                stackView.backgroundColor = .systemBlue
            }
            return stackView
        }()
        
        
        return stackView
    }
}
