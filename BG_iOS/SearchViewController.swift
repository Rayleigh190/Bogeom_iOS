//
//  SearchViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/05/20.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var imgView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        imgView.image = image
        imgView.transform = imgView.transform.rotated(by: .pi/2)
    }

    

}
