//
//  HomeHeader.swift
//  RestaurantMenu
//
//  Created by user on 21/10/2021.
//

import UIKit
import ImageSlideshow

class HomeHeaderViewController: UIViewController {

    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var restaurantStatusView: UIView!
    @IBOutlet weak var restaurantStatusLabel: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var ratingFace: UIImageView!
    @IBOutlet weak var ratingStatus: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    
    private let slideshowImages = GeneralInfoManager.getGeneralInfo()?.featuredItems
    
    var categoryItems = [CategoryItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Slider...
        setSlideShow(with: slideshowImages ?? [])
        
        // Setting Info...
        deliveryTimeLabel.text = "Within \(GeneralInfoManager.getGeneralInfo()!.Delivery_Time) min"
        deliveryChargeLabel.text = "(KD \(String(format: "%.3f", GeneralInfoManager.getGeneralInfo()!.AVG_Service_Fee)))"
        restaurantStatusView.isHidden = GeneralInfoManager.getGeneralInfo()!.status == "OPEN"
        restaurantStatusLabel.text = GeneralInfoManager.getGeneralInfo()!.status
        
        // Getting reviews
        ReviewsApi.getAverageRating(onSuccess: { restaurantRating in
            DispatchQueue.main.async {
                let reviewsManager = ReviewsManager(rating: restaurantRating.getRating())
                self.ratingFace.image = UIImage(named: reviewsManager.getFace())
                self.ratingStatus.text = reviewsManager.getStatus()
                self.ratingCount.text = restaurantRating.total > 1 ? "(\(restaurantRating.total) reviews)" : "(\(restaurantRating.total) review)"
                self.ratingView.isHidden = false
            }
        }, onFailure: { error in
            print(error)
        })
        
    }
    
    func setSlideShow(with images: [String]) -> Void {
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.delegate = self
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.red
        slideshow.pageIndicator = pageIndicator

        // Adding images...
        var webImageSource = [SDWebImageSource]()
        for image in images {
            let urlString = RestaurantInfoManager.backendURL + "/static/media/" + image
            webImageSource.append(SDWebImageSource(urlString: urlString)!)
        }
        slideshow.setImageInputs(webImageSource)
        
    }
    
    
    func setPromotion(categoryItems: [CategoryItem]) {
        var bestDiscount: Double = 0
        for categoryItem in categoryItems {
            for menuItem in categoryItem.menuItems {
                if menuItem.discount > bestDiscount {
                    bestDiscount = menuItem.discount
                    promotionLabel.text = "\(menuItem.discount)% on \(menuItem.name)"
                }
            }
        }
    }
}

extension HomeHeaderViewController: ImageSlideshowDelegate {}
