//
//  ReviewsCell.swift
//  Chicken On Fire
//
//  Created by user on 25/11/2021.
//

import UIKit

class ReviewsCell: UITableViewCell {
    
    @IBOutlet weak var ratingFace: UIImageView!
    @IBOutlet weak var ratingStatus: UILabel!
    @IBOutlet weak var ratingDate: UILabel!
    @IBOutlet weak var ratingMessage: UILabel!
    @IBOutlet weak var ratingUsername: UILabel!
    @IBOutlet weak var divider: UIView!
    
    static let identifier = "ReviewsCell"
    static func nib() -> UINib {
        return UINib(nibName: "ReviewsCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(review: Review, hasDivider: Bool) -> Void {
        let rating = Rating(orderPackaginRating: review.orderPackaginRating, valueForMoneyRating: review.valueForMoneyRating, deliveryTimeRating: review.deliveryTimeRating, qualityOfFoodRating: review.qualityOfFoodRating)
        let reviewsManager = ReviewsManager(rating: rating)
        ratingFace.image = UIImage(named: reviewsManager.getFace())
        ratingStatus.text = reviewsManager.getStatus()
        ratingDate.text = review.date
        ratingMessage.text = review.comment
        ratingUsername.text = review.userName
        divider.isHidden = !hasDivider
    }
    
}
