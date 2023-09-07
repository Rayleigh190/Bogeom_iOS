//
//  BlogReviewViewController.swift
//  BG_iOS
//
//  Created by 우진 on 2023/09/06.
//

import UIKit
import Alamofire

class BlogReviewViewController: UIViewController {
    
    var itemName: String?
    var reviewData: BlogReviewAPIResponse?
    var clickedIndex: Int?
    
    @IBOutlet weak var longTitleLabel: UILabel!
    @IBOutlet weak var blogReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blogReviewTableView.delegate = self
        blogReviewTableView.dataSource = self
        longTitleLabel.text = "\(itemName!)의 블로그 리뷰"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BaseYellow")
        changeStatusBarBgColor(bgColor: UIColor(named: "BaseYellow"))
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        changeStatusBarBgColor(bgColor: UIColor.white)
    }
    
    func changeStatusBarBgColor(bgColor: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
    
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = bgColor
    
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
    
}

extension BlogReviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (reviewData?.blog.reviews.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = blogReviewTableView.dequeueReusableCell(withIdentifier: "BlogReviewCell", for: indexPath) as? BlogReviewCell else { return UITableViewCell() }
        
        customCell.blogTitleLabel.text = reviewData?.blog.reviews[indexPath.row].title.htmlToPlainText
        customCell.blogContentLabel.text = reviewData?.blog.reviews[indexPath.row].description.htmlToPlainText
        customCell.blogNameLabel.text = reviewData?.blog.reviews[indexPath.row].bloggername.htmlToPlainText
        customCell.blogDateLabel.text = "작성일 : \(reviewData?.blog.reviews[indexPath.row].postdate.htmlToPlainText ?? "20000101")"
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndex = indexPath.row
        self.performSegue(withIdentifier: "showBlogReviewDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBlogReviewDetail" {
            let vc = segue.destination as? BlogReviewDetailViewController
            vc?.blogLink = reviewData?.blog.reviews[clickedIndex!].link
//            vc?.enuri_link = enuri_link
//            vc?.danawa_link = danawq_link
//            vc?.naver_link = naver_link
        }
    }
    
    
}


extension String {
    var htmlToPlainText: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue // Specify UTF-8 encoding
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return self
        }
    }
}
