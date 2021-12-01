//
//  TabBarViewController.swift
//  RestaurantMenu
//
//  Created by user on 23/10/2021.
//

import UIKit
import Foundation

protocol MenuTabBarDelegate {
    func didChangeIndex(indexPath: IndexPath)
}

class TabBarViewController: UIViewController {
    
    @IBOutlet var tabBar: UIView!
    @IBOutlet var tabBarCollectionView: UICollectionView!
    
    var menuCategories = [CategoryItem]()
    var menuDelegate: MenuDelegate?
    var tabBarDelegate: MenuTabBarDelegate?
    
    var selectedIndex = 0
    let language = LanguageManager.language

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarCollectionView.register(MenuTabBarCell.nib(), forCellWithReuseIdentifier: MenuTabBarCell.identifier)
        tabBarCollectionView.delegate = self
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.transform = CGAffineTransform(scaleX: language == "ar" ? -1.0 : 1.0, y: 1.0)
        
        
        tabBarDelegate = self
        
    }
    
    func setCategoryItems(categoryItems: [CategoryItem]) -> Void {
        menuCategories = categoryItems
        tabBarCollectionView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategorySheetSegue" {
            let categorySheetVC = segue.destination as! CatergorySheetViewController
            categorySheetVC.menuDelegate = menuDelegate
            categorySheetVC.tabBarDelegate = tabBarDelegate
            categorySheetVC.categoryItems = menuCategories
            
            
        }
    }
    
}


extension TabBarViewController: UICollectionViewDelegate, UICollectionViewDataSource, MenuTabBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabBarCollectionView.dequeueReusableCell(withReuseIdentifier: MenuTabBarCell.identifier, for: indexPath) as! MenuTabBarCell
        cell.configure(with: language == "en" ? menuCategories[indexPath.row].title : menuCategories[indexPath.row].titleAr, selected: self.selectedIndex == indexPath.row)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabBarDelegate?.didChangeIndex(indexPath: indexPath)
        menuDelegate?.didSelectCategoryIndex(index: indexPath.row)
        
    }
    
    func didChangeIndex(indexPath: IndexPath) {
        if selectedIndex == indexPath.row { return }
        
        selectedIndex = indexPath.row
        
        let contentOffset = tabBarCollectionView.contentOffset
        tabBarCollectionView.reloadData()
        tabBarCollectionView.layoutIfNeeded()
        tabBarCollectionView.setContentOffset(contentOffset, animated: false)
        tabBarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}




