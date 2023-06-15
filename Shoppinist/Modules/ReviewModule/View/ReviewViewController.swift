//
//  ReviewViewController.swift
//  Shoppinist
//
//  Created by Soha Ahmed Hamdy on 15/06/2023.
//

import UIKit

class ReviewViewController: UIViewController {
    var reviewViewModel: ReviewViewModel?
    var reviewList : [Review]?
    @IBOutlet weak var tableViewReview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        reviewViewModel = ReviewViewModel()
        reviewList = reviewViewModel?.getReviews()
        tableViewReview.reloadData()
        
    }

}

extension ReviewViewController : UITabBarDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
        
        // cell radius
        cell.backView.layer.cornerRadius = 20.0
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = UIColor.darkGray.cgColor
        
        cell.clipsToBounds = true
        cell.reviewImage?.layer.cornerRadius = 38.0
        cell.reviewImage?.contentMode = .scaleAspectFill
        cell.reviewImage?.clipsToBounds = true
        cell.backView.clipsToBounds = true
        
        cell.reviewImage.image = UIImage(named: reviewList?[indexPath.row].image ?? "")
        cell.reviewText.text = reviewList?[indexPath.row].text ?? ""
        cell.reviewRate.rating = reviewList?[indexPath.row].rate ?? 0.00
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
