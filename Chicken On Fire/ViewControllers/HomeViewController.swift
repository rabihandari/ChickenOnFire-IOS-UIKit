//
//  ViewController.swift
//  RestaurantMenu
//
//  Created by user on 18/10/2021.
//

import UIKit
import Foundation
import SideMenu
import ImageSlideshow
import NicoProgress

protocol MenuDelegate {
    func didSelectCategoryIndex(index: Int)
}

class HomeViewController: UIViewController {
    
    @IBOutlet var toolbar: UIView!
    @IBOutlet var tabbar: UIView!
    @IBOutlet var header: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var basketButton: CustomButton!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var toolbarTitle: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDesc: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryChargeLabel: UILabel!
    @IBOutlet weak var restaurantStatusView: UIView!
    @IBOutlet weak var restaurantStatusLabel: UILabel!
    @IBOutlet weak var ratingView: UIStackView!
    @IBOutlet weak var ratingFace: UIImageView!
    @IBOutlet weak var ratingStatus: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
    @IBOutlet weak var progressView: NicoProgressBar!
    @IBOutlet weak var headerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var burgerButton: CardView!
    @IBOutlet weak var searchButton: CardView!
    
    private let slideshowImages = GeneralInfoManager.getGeneralInfo()?.featuredItems
    private var categoryItems = [CategoryItem]()
    
    var sideMenu: SideMenuNavigationController?
    var restaurantRating: RestaurantRating?
    var tabBarVC = TabBarViewController()
    var searchVC = MenuSearchViewController()
    
    let language = LanguageManager.language
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        basketButton.isEnabled = false
        basketButton.active = false
        
        // Setting Side Menu
        let sideMenuViewController = storyboard?.instantiateViewController(identifier: "SideMenuView") as! SideMenuViewController
        sideMenuViewController.mainNavigationController = self.navigationController
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuViewController)
        sideMenu?.leftSide = language != "ar"
        sideMenu?.setNavigationBarHidden(true, animated: false)
        sideMenu?.menuWidth = UIScreen.main.bounds.width * 0.75
        sideMenu?.sideMenuDelegate = self
        if language != "ar" {
            SideMenuManager.default.leftMenuNavigationController = sideMenu
        } else {
            SideMenuManager.default.rightMenuNavigationController = sideMenu
        }
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        
        // Getting Menu
        menuTableView.register(MenuItemViewCell.nib(), forCellReuseIdentifier: MenuItemViewCell.identifier)
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorColor = UIColor.clear
        MenuApi.getMenu(branchID: GeneralAreaManager.getSavedArea().branchID, onSuccess: { categoryItems in
            DispatchQueue.main.async {
                self.categoryItems = categoryItems
                self.menuTableView.reloadData()
                
                self.tabBarVC.setCategoryItems(categoryItems: categoryItems)
                
                self.progressView.isHidden = true
                self.basketButton.isEnabled = true
                self.basketButton.active = true
                self.tabbar.frame = CGRect(x: 0, y: self.header.frame.height - self.tabbar.frame.height, width: self.tabbar.frame.width, height: self.tabbar.frame.height)
                
            
                
            }
        }, onFailure: { error in
            print(error)
        })
        
        
        // Getting reviews
        ReviewsApi.getAverageRating(onSuccess: { restaurantRating in
            DispatchQueue.main.async {
                self.restaurantRating = restaurantRating
                let reviewsManager = ReviewsManager(rating: restaurantRating.getRating())
                self.ratingFace.image = UIImage(named: reviewsManager.getFace())
                self.ratingStatus.text = reviewsManager.getStatus()
                self.ratingCount.text = restaurantRating.total > 1 ? "(\(restaurantRating.total) " + "reviews".localized() + ")" : "(\(restaurantRating.total) " + "review".localized() + ")"
                UIView.animate(withDuration: 0.3, animations: {
                    self.ratingView.isHidden = false
                },completion: { _ in
                    self.tabbar.frame = CGRect(x: 0, y: self.header.frame.height - self.tabbar.frame.height, width: self.tabbar.frame.width, height: self.tabbar.frame.height)
                    self.tabbar.isHidden = false
                })
            }
        }, onFailure: { error in
            print(error)
        })
        
        
        // Setting Slider...
        setSlideShow(with: slideshowImages ?? [])
        
        
        // Setting Info...
        restaurantName.text = RestaurantInfoManager.name
        restaurantDesc.text = language == "ar" ? GeneralInfoManager.getGeneralInfo()!.Cuisine_Second_Language : GeneralInfoManager.getGeneralInfo()!.Cuisine
        deliveryTimeLabel.text = "Within".localized() + " \(GeneralInfoManager.getGeneralInfo()!.Delivery_Time) " + "min".localized()
        deliveryChargeLabel.text = "(" + "KD".localized()  + " \(String(format: "%.3f", GeneralInfoManager.getGeneralInfo()!.AVG_Service_Fee)))"
        restaurantStatusView.isHidden = GeneralInfoManager.getGeneralInfo()!.status == "OPEN"
        restaurantStatusLabel.text = GeneralInfoManager.getGeneralInfo()!.status?.localized()
        
        
        // Setting Tab bar
        headerBottomConstraint.constant += tabbar.frame.height
        
        
        // Setting UI...
        toolbarTitle.text = RestaurantInfoManager.name
        burgerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSideMenuTap(_:))))
        searchButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSearchTap(_:))))
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSegue" {
            tabBarVC = segue.destination as! TabBarViewController
            tabBarVC.menuDelegate = self
        } else if segue.identifier == "MenuSearchSegue" {
            searchVC = segue.destination as! MenuSearchViewController
            searchVC.categoryItems = categoryItems
        } else if segue.identifier == "BasketSegue" {
            let basketVC = segue.destination as! BasketViewController
            basketVC.categoryItems = categoryItems
        } else if segue.identifier == "ReviewsSegue" {
            let vc = segue.destination as! ReviewsViewController
            vc.restaurantRating = restaurantRating
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if BasketManager.basketItems.count > 0 {
            basketButton.isHidden = false
            updateBasketButtonUI()
        } else {
            basketButton.isHidden = true
        }
        
        if menuTableView.contentOffset.y > header.frame.height - toolbar.frame.height - tabbar.frame.height - UIApplication.topSafeAreaHeight {
            UIApplication.shared.statusBarUIView?.backgroundColor = .white
        } else {
            UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        header.frame.size.height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        menuTableView.tableHeaderView = header
        
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
                    promotionLabel.text = "\(menuItem.discount)% " + "on".localized() + " \(menuItem.name)"
                }
            }
        }
    }
    
    
    func updateBasketButtonUI() {
        var totalPrice: Double = 0
        for basketItem in BasketManager.basketItems {
            totalPrice += basketItem.totalPrice
        }
        basketButton.leftTitle = "KD \(String(format: "%.3f", totalPrice))"
        
        // Above minimum order...
        let aboveMinimumOrder = totalPrice >= GeneralInfoManager.getGeneralInfo()!.Minimum_Order
        basketButton.active = aboveMinimumOrder
        basketButton.isEnabled = aboveMinimumOrder
    }
    
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Order Success", message: "Your order has been successfully submited. You should receive your order in \(GeneralInfoManager.getGeneralInfo()!.Delivery_Time) min", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openSideMenu(){
        present(sideMenu!, animated: true, completion: nil)
    }
    
    
    @objc func openSideMenuTap(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
    }
    
    @objc func openSearchTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MenuSearchStoryboard") as! MenuSearchViewController
        vc.categoryItems = categoryItems
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryItems.count
        
    }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("MenuSectionHeader", owner: self, options: nil)?.first as! MenuSectionHeader
        header.title.text = language == "en" ? categoryItems[section].title : categoryItems[section].titleAr
        header.layer.zPosition = -1
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems[section].menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: MenuItemViewCell.identifier, for: indexPath) as! MenuItemViewCell
        cell.configure(with: categoryItems[indexPath.section].menuItems[indexPath.row])
        
        // Setting borders...
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: cell.contentView.frame.size.height - 1, width: cell.contentView.frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        if indexPath.row != categoryItems[indexPath.section].menuItems.count - 1 {
            cell.contentView.layer.addSublayer(bottomBorder)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let customizeOrderVC = storyboard?.instantiateViewController(identifier: "CustomizeOrder") as! CustomizeViewController
        customizeOrderVC.menuItem = categoryItems[indexPath.section].menuItems[indexPath.row]
        navigationController?.pushViewController(customizeOrderVC, animated: true)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if menuTableView.contentOffset.y > header.frame.height - toolbar.frame.height - tabbar.frame.height - UIApplication.topSafeAreaHeight {
            toolbar.isHidden = false
            tabbar.frame = CGRect(x: 0, y: toolbar.frame.height + UIApplication.topSafeAreaHeight, width: tabbar.frame.width, height: tabbar.frame.height)
            UIApplication.shared.statusBarUIView?.backgroundColor = .white
        } else {
            menuTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            toolbar.isHidden = true
            self.tabbar.frame = CGRect(x: 0, y: self.header.frame.height - self.tabbar.frame.height - scrollView.contentOffset.y, width: self.tabbar.frame.width, height: self.tabbar.frame.height)
            UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        }
    }
}




extension HomeViewController: MenuDelegate {
    func didSelectCategoryIndex(index: Int) {
        menuTableView.contentInset = UIEdgeInsets(top: 100 + UIApplication.topSafeAreaHeight, left: 0, bottom: 0, right: 0)
        menuTableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
    }
    
}

extension HomeViewController: SideMenuNavigationControllerDelegate {

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
    }

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        if menuTableView.contentOffset.y > header.frame.height - toolbar.frame.height - tabbar.frame.height - UIApplication.topSafeAreaHeight {
            UIApplication.shared.statusBarUIView?.backgroundColor = .white
        } else {
            UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        }
    }
}


extension HomeViewController: ImageSlideshowDelegate {}
