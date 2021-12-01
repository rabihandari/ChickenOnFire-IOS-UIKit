//
//  AddReviewViewController.swift
//  Chicken On Fire
//
//  Created by user on 25/11/2021.
//

import UIKit
import Cosmos
import NicoProgress

class AddReviewViewController: UIViewController {
    
    @IBOutlet weak var orderPackagingView: UIView!
    @IBOutlet weak var valueForMoneyView: UIView!
    @IBOutlet weak var deliveryTimeView: UIView!
    @IBOutlet weak var qualityOfFoodView: UIView!
    @IBOutlet weak var orderPackagingStars: CosmosView!
    @IBOutlet weak var valueForMoneyStars: CosmosView!
    @IBOutlet weak var deliveryTimeStars: CosmosView!
    @IBOutlet weak var qualityOfFoodStars: CosmosView!
    @IBOutlet weak var leaveCommentParagraph: UILabel!
    @IBOutlet weak var addReviewButton: CustomButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    var orderPackagingRating: Double = 0
    var valueForMoneyRating: Double = 0
    var deliveryTimeRating: Double = 0
    var qualityOfFoodRating: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leaveCommentParagraph.text = "Your feedback is important. Let us know your thoughts, suggestions, or if there is anything you didn't like in \(RestaurantInfoManager.name)"
        
        orderPackagingStars.didTouchCosmos = { rating in
            self.orderPackagingRating = rating
            self.valueForMoneyView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.orderPackagingView.frame.origin.x -= 500
                }, completion: { _ in
                    self.orderPackagingView.isHidden = true
                })
            })
        }
        
        valueForMoneyStars.didTouchCosmos = { rating in
            self.valueForMoneyRating = rating
            self.deliveryTimeView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.valueForMoneyView.frame.origin.x -= 500
                }, completion: { _ in
                    self.valueForMoneyView.isHidden = true
                })
            })
        }
        
        deliveryTimeStars.didTouchCosmos = { rating in
            self.deliveryTimeRating = rating
            self.qualityOfFoodView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.deliveryTimeView.frame.origin.x -= 500
                }, completion: { _ in
                    self.deliveryTimeView.isHidden = true
                })
            })
        }

        qualityOfFoodStars.didTouchCosmos = { rating in
            self.qualityOfFoodRating = rating
            self.addReviewButton.active = true
            self.addReviewButton.isEnabled = true
        }
        
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ReviewsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    
    @IBAction func addReview(_ sender: Any) {
        progressView.isHidden = false
        let rating = Rating(orderPackaginRating: orderPackagingRating, valueForMoneyRating: valueForMoneyRating, deliveryTimeRating: deliveryTimeRating, qualityOfFoodRating: qualityOfFoodRating)
        let comment = commentField.text!
        let email = UserAccountManager.savedUserAccount().email
        
        ReviewsApi.addReview(email: email, rating: rating, comment: comment, onSuccess: {
            DispatchQueue.main.async {
                self.goBack(self)
                self.progressView.isHidden = true
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                self.progressView.isHidden = true
                print(error)
            }
        })
    }
    

}
