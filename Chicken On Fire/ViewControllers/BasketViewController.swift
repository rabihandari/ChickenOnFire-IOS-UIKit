//
//  BasketViewController.swift
//  Chicken On Fire
//
//  Created by user on 14/11/2021.
//

import UIKit

class BasketViewController: UIViewController {
    
    @IBOutlet weak var basketTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!

    var categoryItems: [CategoryItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting table view...
        basketTableView.register(BasketViewCell.nib(), forCellReuseIdentifier: BasketViewCell.identifier)
        basketTableView.delegate = self
        basketTableView.dataSource = self
        basketTableView.separatorColor = UIColor.clear
        
        // Initializing UI....
        errorLabel.text = "The minimum order amount is \(GeneralInfoManager.getGeneralInfo()!.Minimum_Order) KD"
        
        updatePrice()
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkout(_ sender: Any) {
        if !UserAccountManager.savedUserAccount().authenticated {
            goToSignIn()
            return
        }
        
        if UserAddressManager.userAddresses.count == 0 {
            goToLocation()
            return
        }
        
        goToCheckout()
        
    }
    
    
    private func goToLocation() {
        let destination = storyboard?.instantiateViewController(identifier: "AddLocation") as! AddLocationViewController
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    private func goToSignIn() {
        let destination = storyboard?.instantiateViewController(identifier: "SignInStoryboard") as! SignInViewController
        destination.guestEnabled = true
        destination.onSuccess = { userAccount in
            UserAccountManager.setUserAccount(account: userAccount)
            
            if UserAddressManager.userAddresses.count == 0 {
                self.goToLocation()
            } else {
                self.goToCheckout()
            }
            
        }
        destination.onGuestLogin = {
            if UserAddressManager.userAddresses.count == 0 {
                self.goToLocation()
            } else {
                self.goToCheckout()
            }
        }
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    private func goToCheckout() {
        let destination = storyboard?.instantiateViewController(identifier: "Checkout") as! CheckoutViewController
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    private func updatePrice() {
        var result: Double = 0
        for basketItem in BasketManager.basketItems {
            result += basketItem.totalPrice
        }
        totalPriceLabel.text = "\(String(format: "%.3f", result)) K.D"
        enableCheckoutButton(enabled: isValid(subtotal: result))
        
    }
    
    
    private func enableCheckoutButton(enabled: Bool) {
        checkoutButton.isEnabled = enabled
        checkoutButton.active = enabled
    }
    
    
    private func isValid(subtotal: Double) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.errorLabel.isHidden = subtotal >= GeneralInfoManager.getGeneralInfo()!.Minimum_Order
        })
        
        if subtotal < GeneralInfoManager.getGeneralInfo()!.Minimum_Order {
            return false
        }
        
        for basketItem in BasketManager.basketItems {
            if !getMenuItems().contains(where: { menuItem in
                basketItem.itemID == menuItem.id
            }) {
                return false
            }
        }
        
        return true
    }
    
    
    private func getMenuItems() -> [MenuItem] {
        var menuItems = [MenuItem]()
        for categoryItem in categoryItems ?? [] {
            for menuItem in categoryItem.menuItems {
                if !menuItems.contains(where: {
                    $0.id == menuItem.id
                }) {
                    menuItems.append(menuItem)
                }
            }
        }
        return menuItems
    }

}


extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        BasketManager.basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketViewCell.identifier, for: indexPath) as! BasketViewCell
        let basketItem = BasketManager.basketItems[indexPath.row]
        cell.configure(basketItem: basketItem, hasDivider: indexPath.row != BasketManager.basketItems.count - 1, available: getMenuItems().contains(where: { menuItem in menuItem.id == basketItem.itemID }))
        cell.onItemChange = {
            tableView.reloadRows(at: [indexPath], with: .none)
            self.updatePrice()
        }
        cell.onItemRemoved = {
            tableView.deleteRows(at: [indexPath], with: .right)
            self.updatePrice()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                tableView.reloadData()
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    

    
    
}
