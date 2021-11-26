//
//  FavouritesViewController.swift
//  Chicken On Fire
//
//  Created by user on 23/11/2021.
//

import UIKit
import NicoProgress

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var noFavouritesView: UIStackView!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting menu...
        favouritesTableView.register(MenuItemViewCell.nib(), forCellReuseIdentifier: MenuItemViewCell.identifier)
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.separatorColor = UIColor.clear
        
        
        // Getting favourites...
        progressView.isHidden = false
        let account = UserAccountManager.savedUserAccount()
        FavouritesApi.getFavourites(email: account.email, branchID: GeneralAreaManager.getSavedArea().branchID, onSuccess: { menuItems in
            DispatchQueue.main.async {
                self.menuItems = menuItems
                self.progressView.isHidden = true
                self.favouritesTableView.reloadData()
                
                if menuItems.isEmpty {
                    self.noFavouritesView.isHidden = false
                }
                
            }
        }, onFailure: { error in
            DispatchQueue.main.async {
                print(error)
                self.progressView.isHidden = true
            }
        })
        
    }
    

    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}



extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemViewCell.identifier, for: indexPath) as! MenuItemViewCell
        cell.configure(with: menuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let customizeOrderVC = storyboard?.instantiateViewController(identifier: "CustomizeOrder") as! CustomizeViewController
        customizeOrderVC.menuItem = menuItems[indexPath.row]
        customizeOrderVC.onBackPressed = {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: FavouritesViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        navigationController?.pushViewController(customizeOrderVC, animated: true)
    }
    
    
}

