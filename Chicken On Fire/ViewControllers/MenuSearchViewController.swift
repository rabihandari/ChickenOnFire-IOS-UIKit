//
//  MenuSearchViewController.swift
//  Chicken On Fire
//
//  Created by user on 08/11/2021.
//

import UIKit

class MenuSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var categoryItems: [CategoryItem]?
    var menuItems = [MenuItem]()
    var filteredMenuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting search bar...
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.red
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        if let cancelButton : UIButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
        searchBar.becomeFirstResponder()
        
        // Setting menu...
        tableView.register(MenuItemViewCell.nib(), forCellReuseIdentifier: MenuItemViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        setMenuItems()
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMenuItems = menuItems
            tableView.reloadData()
            return
        }
        
        filteredMenuItems = menuItems.filter { item in
            item.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    
    func setMenuItems() -> Void {
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
        self.menuItems = menuItems
        self.filteredMenuItems = menuItems
    }
    
}


extension MenuSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemViewCell.identifier, for: indexPath) as! MenuItemViewCell
        cell.configure(with: filteredMenuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let customizeOrderVC = storyboard?.instantiateViewController(identifier: "CustomizeOrder") as! CustomizeViewController
        customizeOrderVC.menuItem = filteredMenuItems[indexPath.row]
        navigationController?.pushViewController(customizeOrderVC, animated: true)
    }
    
    
}
