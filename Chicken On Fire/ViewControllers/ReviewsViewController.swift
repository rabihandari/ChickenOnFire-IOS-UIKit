//
//  ReviewsViewController.swift
//  Chicken On Fire
//
//  Created by user on 25/11/2021.
//

import UIKit
import NicoProgress
import Cosmos

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var ratingFace: UIImageView!
    @IBOutlet weak var ratingStatus: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var orderPackagingStars: CosmosView!
    @IBOutlet weak var valueForMoneyStars: CosmosView!
    @IBOutlet weak var deliveryTimeStars: CosmosView!
    @IBOutlet weak var qualityOfFoodStars: CosmosView!
    @IBOutlet weak var orderPackagingLabel: UILabel!
    @IBOutlet weak var valueForMoneyLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var qualityOfFoodLabel: UILabel!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    var reviews = [Review]()
    var restaurantRating: RestaurantRating?
    
    let data = ["Row 1", "Row 2", "Row 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        reviewsTableView.register(ReviewsCell.nib(), forCellReuseIdentifier: ReviewsCell.identifier)
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.separatorColor = .clear
        
        guard let restaurantRating = restaurantRating else {
            return
        }
        
        // Setting stars and values...
        let reviewManager = ReviewsManager(rating: restaurantRating.getRating())
        ratingFace.image = UIImage(named: reviewManager.getFace())
        ratingStatus.text = reviewManager.getStatus()
        ratingCount.text = "Based on \(restaurantRating.total) " + (restaurantRating.total > 1 ? "reviews" : "review")
        orderPackagingStars.rating = restaurantRating.orderPackaginRating
        valueForMoneyStars.rating = restaurantRating.valueForMoneyRating
        deliveryTimeStars.rating = restaurantRating.deliveryTimeRating
        qualityOfFoodStars.rating = restaurantRating.qualityOfFoodRating
        orderPackagingLabel.text = String(format: "%.1f", restaurantRating.orderPackaginRating)
        valueForMoneyLabel.text = String(format: "%.1f", restaurantRating.valueForMoneyRating)
        deliveryTimeLabel.text = String(format: "%.1f", restaurantRating.deliveryTimeRating)
        qualityOfFoodLabel.text = String(format: "%.1f", restaurantRating.qualityOfFoodRating)
        
        
        // Getting reviews...
        ReviewsApi.getReviews(onSuccess: { reviews in
            DispatchQueue.main.async {
                self.reviews = reviews
                self.progressView.isHidden = true
                self.reviewsTableView.reloadData()
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                print(error)
            }
        })
        
        
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addReview(_ sender: Any) {
        let userAccount = UserAccountManager.savedUserAccount()
        if !userAccount.authenticated {
            let destination = storyboard?.instantiateViewController(identifier: "SignInStoryboard") as! SignInViewController
            destination.guestEnabled = false
            destination.onSuccess = { userAccount in
                UserAccountManager.setUserAccount(account: userAccount)
                
                let vc = self.storyboard?.instantiateViewController(identifier: "AddReviewStoryboard") as! AddReviewViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.navigationController?.pushViewController(destination, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "AddReviewStoryboard") as! AddReviewViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        header.frame.size.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        reviewsTableView.tableHeaderView = header
        
    }

}


extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsCell.identifier, for: indexPath) as! ReviewsCell
        cell.configure(review: reviews[indexPath.row], hasDivider: indexPath.row != reviews.count - 1)
        return cell
    }
    
    
}
