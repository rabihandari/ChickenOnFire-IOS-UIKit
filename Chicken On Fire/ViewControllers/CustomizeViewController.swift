//
//  CustomizeViewController.swift
//  Chicken On Fire
//
//  Created by user on 08/11/2021.
//

import UIKit
import NicoProgress

class AddonCategroyModel{
    let addonCategory: AddonCategory
    var isOpened: Bool
    var isSatisfied: Bool
    
    init(addonCategory: AddonCategory, isOpened: Bool) {
        self.addonCategory = addonCategory
        self.isOpened = isOpened
        self.isSatisfied = addonCategory.optional
    }
}


class CustomizeViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var progressBar: NicoProgressBar!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var discountLine: UIView!
    @IBOutlet weak var itemNewPrice: UILabel!
    @IBOutlet weak var customizationTableView: UITableView!
    @IBOutlet weak var specialRequestField: UITextField!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var addToBasketButton: CustomButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var menuItem: MenuItem?
    var onBackPressed: (() -> Void)?
    var addOnCategoriesModel = [AddonCategroyModel]()
    var selectedAddons = [AddonCategory: [Addon]]()
    
    var quantity = 1
    var specialRequest = ""
    var totalPrice: Double = 0
    var isFavoured = false {
        didSet {
            favouriteButton.setImage(UIImage(systemName: isFavoured ? "heart.fill" : "heart"), for: .normal)
            favouriteButton.tintColor = isFavoured ? .red : .darkGray
        }
    }
    var favouritesLoading = true {
        didSet {
            favouriteButton.isEnabled = !favouritesLoading
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear

        // Initializing Info...
        guard let menuItem = self.menuItem else {
            return
        }
        itemName.text = menuItem.name
        let urlString = RestaurantInfoManager.backendURL + menuItem.image
        headerImage.sd_setImage(with: URL(string: urlString))
        itemDesc.text = menuItem.desicription
        itemPrice.text = "KD \(String(format: "%.3f", menuItem.price))"
        addToBasketButton.leftTitle = "KD \(String(format: "%.3f", menuItem.price))"
        if menuItem.discount > 0 {
            let newPrice = menuItem.price - (menuItem.price * menuItem.discount/100)
            itemNewPrice.text = "KD \(String(format: "%.3f", newPrice))"
            itemPrice.textColor = .darkGray
            discountLine.isHidden = false
            itemNewPrice.isHidden = false
            addToBasketButton.leftTitle = "KD \(String(format: "%.3f", newPrice))"
        }
        
        // Setting table view...
        customizationTableView.register(CustomizationSection.nib(), forCellReuseIdentifier: CustomizationSection.identifier)
        customizationTableView.register(CustomizationCellSingle.nib(), forCellReuseIdentifier: CustomizationCellSingle.identifier)
        customizationTableView.register(CustomizationCellMultiple.nib(), forCellReuseIdentifier: CustomizationCellMultiple.identifier)
        customizationTableView.separatorColor = .clear
        customizationTableView.delegate = self
        customizationTableView.dataSource = self
        
        // Getting Addons...
        MenuApi.getAddon(ofID: menuItem.id, branchID: GeneralAreaManager.getSavedArea().branchID, onSuccess: { addonCategories in
            DispatchQueue.main.async {
                for addonCategory in addonCategories {
                    self.addOnCategoriesModel.append(AddonCategroyModel(addonCategory: addonCategory, isOpened: true))
                    self.selectedAddons[addonCategory] = [Addon]()
                }
                self.customizationTableView.reloadData()
                self.progressBar.isHidden = true
                self.addToBasketButton.active = true
                if addonCategories.count == 0 {
                    self.divider.isHidden = true
                }
                
            }
        }, onFailure: { error in
            print("Error getting addons")
        })
        
        
        // Checking is favoured...
        let account = UserAccountManager.savedUserAccount()
        if account.authenticated {
            FavouritesApi.checkIsFavoured(email: account.email, menuItemId: menuItem.id, onSuccess: { favoured in
                DispatchQueue.main.async {
                    self.isFavoured = favoured
                    self.favouritesLoading = false
                }
            }, onFailure: { error in
                print(error)
            })
        } else {
            self.favouritesLoading = false
        }
        
        updateBasketButton()
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headerView.frame.size.height = headerView.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
        footerView.frame.size.height = footerView.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        headerView.frame.size.height = headerView.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
        footerView.frame.size.height = footerView.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0)).height
    }
    
    
    @IBAction func goBack() {
        if let onBackPressed = onBackPressed {
            onBackPressed()
            return
        }
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                UIApplication.shared.statusBarUIView?.backgroundColor = .clear
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func incrementCount() {
        quantity += 1
        itemQuantity.text = String(quantity)
        updateBasketButton()
        
    }
    
    @IBAction func decrementCount() {
        if quantity == 1 { return }
        quantity -= 1
        itemQuantity.text = String(quantity)
        updateBasketButton()
        
    }
    
    
    @IBAction func toggleFavourite(_ sender: Any) {
        if favouritesLoading { return }
        
        let account = UserAccountManager.savedUserAccount()
        if !account.authenticated {
            let vc = storyboard?.instantiateViewController(identifier: "SignInStoryboard") as! SignInViewController
            vc.guestEnabled = false
            vc.onSuccess = { userAccount in
                UserAccountManager.setUserAccount(account: userAccount)
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: CustomizeViewController.self) {
                        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                self.toggleFavourite(self)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let menuItem = menuItem else { return }
            
            favouritesLoading = true
            isFavoured = !isFavoured
            FavouritesApi.toggleFavourite(email: account.email, menuItemId: menuItem.id, onSuccess: {
                DispatchQueue.main.async {
                    self.favouritesLoading = false
                }
            }, onFailure: { error in
                DispatchQueue.main.async {
                    print(error)
                    self.favouritesLoading = false
                }
            })
            
        }
        
    }
    
    
    func isMultiple(addonCategory: AddonCategory) -> Bool {
        if addonCategory.chooseMin == 1 && addonCategory.chooseMax == 1 {
            return false
        } else {
            return true
        }
    }
    
    func isSelected(addonCategory: AddonCategory, addon: Addon) -> Bool {
        if selectedAddons[addonCategory]!.contains(addon) {
            return true
        }
        return false
    }
    
    func updateBasketButton() {
        guard let menuItem = menuItem else {
            return
        }
        totalPrice = menuItem.price
        if menuItem.discount > 0 {
            totalPrice = menuItem.price - (menuItem.price * menuItem.discount/100)
        }
        
        for (_, addons) in selectedAddons {
            for addon in addons {
                totalPrice += addon.price
            }
        }
        
        totalPrice = totalPrice * Double(quantity)
        addToBasketButton.leftTitle = "KD \(String(format: "%.3f", totalPrice))"
    }
    
    func updateSatisfaction(addonCategory: AddonCategory) {
        if addonCategory.optional { return }
        
        guard let selectedCategory = addOnCategoriesModel.first(where: {
            $0.addonCategory == addonCategory
        }) else { return }
        selectedCategory.isSatisfied = selectedAddons[addonCategory]!.count >= addonCategory.chooseMin
        
        if selectedCategory.isSatisfied {
            guard let index = addOnCategoriesModel.firstIndex(where: {
                $0.addonCategory == addonCategory
            }) else { return }
            let cell = customizationTableView.cellForRow(at: IndexPath(row: 0, section: index)) as! CustomizationSection
            cell.hideRequired()
        }
    }
    
    @IBAction func addToBasket() {
        
        customizationTableView.contentInset = UIEdgeInsets(top: 60 + UIApplication.topSafeAreaHeight, left: 0, bottom: 0, right: 0)
        for index in 0..<addOnCategoriesModel.count {
            if !addOnCategoriesModel[index].isSatisfied {
                customizationTableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: true)
                guard let cell = customizationTableView.cellForRow(at: IndexPath(row: 0, section: index)) as? CustomizationSection else { return }
                cell.showRequired()
                return
            }
        }
        
        // Add to basket
        guard let menuItem = menuItem else { return }
        var totalAddons: [Addon] = []
        for (_, addons) in selectedAddons {
            for addon in addons {
                totalAddons.append(addon)
            }
        }
        
        let basketItem = BasketItem(itemID: menuItem.id, itemName: menuItem.name, itemNameAr: menuItem.nameAr, imageUrl: RestaurantInfoManager.backendURL + menuItem.image, addons: totalAddons, quantity: quantity, specialRequest: specialRequestField.text!, totalPrice: totalPrice)
        BasketManager.basketItems.append(basketItem)
        navigationController?.popViewController(animated: true)
        print("Added to basket!")
    }

}


extension CustomizeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return addOnCategoriesModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addOnCategoriesModel.count == 0 { return 0 }
        
        let sectionModel = addOnCategoriesModel[section]
        if sectionModel.isOpened {
            return addOnCategoriesModel[section].addonCategory.items.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationSection.identifier, for: indexPath) as! CustomizationSection
            cell.configure(addonCategory: addOnCategoriesModel[indexPath.section].addonCategory, isOpened: addOnCategoriesModel[indexPath.section].isOpened)
            return cell
        } else {
            let addOnCategory = addOnCategoriesModel[indexPath.section].addonCategory
            let addOn = addOnCategory.items[indexPath.row - 1]
            
            if !isMultiple(addonCategory: addOnCategory) {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationCellSingle.identifier, for: indexPath) as! CustomizationCellSingle
                cell.configure(addon: addOn, selected: isSelected(addonCategory: addOnCategory, addon: addOn))
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomizationCellMultiple.identifier, for: indexPath) as! CustomizationCellMultiple
                cell.configure(addon: addOn, selected: isSelected(addonCategory: addOnCategory, addon: addOn))
                return cell
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if indexPath.row == 0 {
            // tapped in section...
            addOnCategoriesModel[indexPath.section].isOpened = !addOnCategoriesModel[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            // tapped on cell...
            let selectedCategory = addOnCategoriesModel[indexPath.section].addonCategory
            let selectedAddon = selectedCategory.items[indexPath.row - 1]
            
            
            if selectedAddons[selectedCategory]!.contains(selectedAddon) {
                // if already selected...
                selectedAddons[selectedCategory]!.removeAll(where: {
                    $0 == selectedAddon
                })
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                // if not selected...
                if cell.isKind(of: CustomizationCellSingle.self) {
                    selectedAddons[selectedCategory]! = [Addon]()
                    selectedAddons[selectedCategory]!.append(selectedAddon)
                    
                    var indexesToReload = [IndexPath]()
                    for index in 1..<selectedCategory.items.count + 1{
                        indexesToReload.append(IndexPath(row: index, section: indexPath.section))
                    }
                    tableView.reloadRows(at: indexesToReload, with: .automatic)
                    
                    // collapse row
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.addOnCategoriesModel[indexPath.section].isOpened = false
                        tableView.reloadSections([indexPath.section], with: .none)
                    })
                    
                } else if cell.isKind(of: CustomizationCellMultiple.self) {
                    if !selectedCategory.optional && selectedAddons[selectedCategory]!.count == selectedCategory.chooseMax {
                        guard let oldAddon = selectedAddons[selectedCategory]!.first else { return }
                        guard let oldAddonIndex = selectedAddons[selectedCategory]!.firstIndex(of: oldAddon) else { return }
                        selectedAddons[selectedCategory]!.remove(at: oldAddonIndex)
                        selectedAddons[selectedCategory]!.append(selectedAddon)
                        
                        var indexesToReload = [IndexPath]()
                        for index in 1..<selectedCategory.items.count + 1{
                            indexesToReload.append(IndexPath(row: index, section: indexPath.section))
                        }
                        tableView.reloadRows(at: indexesToReload, with: .automatic)
                        
                    } else {
                        selectedAddons[selectedCategory]!.append(selectedAddon)
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            updateSatisfaction(addonCategory: selectedCategory)
            updateBasketButton()
            
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > headerImage.frame.height - UIApplication.topSafeAreaHeight {
            toolbar.isHidden = false
            UIApplication.shared.statusBarUIView?.backgroundColor = .white
        } else {
            customizationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            toolbar.isHidden = true
            UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        }
    }
    
}
