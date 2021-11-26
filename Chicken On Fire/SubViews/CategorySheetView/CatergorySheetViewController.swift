//
//  CatergorySheetViewController.swift
//  Chicken On Fire
//
//  Created by user on 06/11/2021.
//

import UIKit

class CatergorySheetViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!

    var categoryItems = [CategoryItem]()
    var menuDelegate: MenuDelegate?
    var tabBarDelegate: MenuTabBarDelegate?
    
    // temps
    var statusBarColor: CGColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting status bar default color
        statusBarColor = UIApplication.shared.statusBarUIView?.backgroundColor?.cgColor
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
        
        // Setting table view
        categoryTableView.register(CategorySheetCell.nib(), forCellReuseIdentifier: CategorySheetCell.identifier)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.separatorColor = UIColor.clear
        
    }
    
    func setCategoryItems(categoryItems: [CategoryItem]) -> Void {
        self.categoryItems = categoryItems
        categoryTableView.reloadData()
    }
    
    @IBAction func hideSheet(sender: AnyObject) {
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(cgColor: statusBarColor ?? CGColor(gray: 0, alpha: 0))
        dismiss(animated: true, completion: nil)
    }

}


extension CatergorySheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategorySheetCell.identifier, for: indexPath) as! CategorySheetCell
        cell.configure(title: categoryItems[indexPath.row].title, number: categoryItems[indexPath.row].menuItems.count, hasDivider: indexPath.row != categoryItems.count - 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
        tabBarDelegate?.didChangeIndex(indexPath: indexPath)
        menuDelegate?.didSelectCategoryIndex(index: indexPath.row)
    }
    
    
}
