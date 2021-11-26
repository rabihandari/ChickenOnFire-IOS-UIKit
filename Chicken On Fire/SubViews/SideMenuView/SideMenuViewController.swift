//
//  SideMenuViewController.swift
//  Chicken On Fire
//
//  Created by user on 08/11/2021.
//

import UIKit

struct SideMenuSection {
    var title: String
    var items: [SideMenuItem]
}

struct SideMenuItem {
    var title: String
    var image: UIImage
    var onClick: (() -> Void)
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [SideMenuSection] = []
    var mainNavigationController: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SideMenuCell.nib(), forCellReuseIdentifier: SideMenuCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        
        // Adding Items...
        let user = UserAccountManager.savedUserAccount()
        
        // Main Section
        var mainItems: [SideMenuItem] = []
        if user.authenticated {
            mainItems.append(SideMenuItem(title: "Sign Out", image: UIImage(systemName: "person")!, onClick: signOut))
        } else {
            mainItems.append(SideMenuItem(title: "Sign In", image: UIImage(systemName: "person")!, onClick: signIn))
        }
        if user.authenticated {
            mainItems.append(SideMenuItem(title: "Favourites", image: UIImage(systemName: "star")!, onClick: openFavourites))
        }
        mainItems.append(SideMenuItem(title: "Share", image: UIImage(systemName: "square.and.arrow.up")!, onClick: shareApp))
        mainItems.append(SideMenuItem(title: "Visit Website", image: UIImage(systemName: "globe")!, onClick: {
            self.openUrl(_url: RestaurantInfoManager.backendURL)
        }))
        mainItems.append(SideMenuItem(title: "Language", image: UIImage(systemName: "textformat")!, onClick: { print("Language") }))
        items.append(SideMenuSection(title: "", items: mainItems))
        
        // Social Media Section
        var socialMediaItems: [SideMenuItem] = []
        socialMediaItems.append(SideMenuItem(title: "Facebook", image: UIImage(named: "ic_facebook_blue")!, onClick: openFacebook))
        socialMediaItems.append(SideMenuItem(title: "Instagram", image: UIImage(named: "ic_instagram")!, onClick: openInstagram))
        socialMediaItems.append(SideMenuItem(title: "Twitter", image: UIImage(named: "ic_twitter")!, onClick: openTwitter))
        items.append(SideMenuSection(title: "Social Media", items: socialMediaItems))
        
        // Contact Us Section
        var contactUsItems: [SideMenuItem] = []
        contactUsItems.append(SideMenuItem(title: "Dial", image: UIImage(systemName: "phone")!, onClick: dialNumber))
        contactUsItems.append(SideMenuItem(title: "Email", image: UIImage(systemName: "envelope")!, onClick: emailVendor))
        items.append(SideMenuSection(title: "Contact Us", items: contactUsItems))
        
        // Others Section
        var otherItems: [SideMenuItem] = []
        otherItems.append(SideMenuItem(title: "Our digital experts", image: UIImage(), onClick: {
            self.openUrl(_url: GeneralInfoManager.getGeneralInfo()!.Digital_Experts)
        }))
        otherItems.append(SideMenuItem(title: "Privacy Policy", image: UIImage(), onClick: {
            self.openUrl(_url: GeneralInfoManager.getGeneralInfo()!.Privacy_Policy)
            
        }))
        items.append(SideMenuSection(title: "Other", items: otherItems))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if items.count == 0 { return }
        
        let account = UserAccountManager.savedUserAccount()
        if items[0].items.contains(where: { sideItem in
            sideItem.title == "Favourites" || sideItem.title == "Favourites"
        }) && account.authenticated {
            return
        }
        
        if items[0].items.contains(where: { sideItem in
            sideItem.title == "Sign In"
        }) && !account.authenticated {
            return
        }
        
        if account.authenticated {
            items[0].items.removeAll(where: { item in
                item.title == "Sign In"
            })
            items[0].items.insert(SideMenuItem(title: "Favourites", image: UIImage(systemName: "star")!, onClick: self.openFavourites), at: 0)
            items[0].items.insert(SideMenuItem(title: "Sign Out", image: UIImage(systemName: "person")!, onClick: self.signOut), at: 0)
            tableView.reloadData()
        } else {
            items[0].items.removeAll(where: { item in
                item.title == "Sign Out" || item.title == "Favourites"
            })
            items[0].items.insert(SideMenuItem(title: "Sign In", image: UIImage(systemName: "person")!, onClick: signIn), at: 0)
            tableView.reloadData()
        }
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("SideMenuSectionCell", owner: self, options: nil)?.first as! SideMenuSectionCell
        if items[section].title.isEmpty {
            header.isHidden = true
        } else {
            header.title.text = items[section].title
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        let sideMenuItem = items[indexPath.section].items[indexPath.row]
        cell.configure(icon: sideMenuItem.image, title: sideMenuItem.title, hasImage: sideMenuItem.image != UIImage(), hasDivider: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if items[section].title.isEmpty {
            return 10
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.section].items[indexPath.row].onClick()
    }
    
    
}


extension SideMenuViewController {
    private func signIn () {
        let vc = storyboard?.instantiateViewController(identifier: "SignInStoryboard") as! SignInViewController
        vc.guestEnabled = false
        vc.onSuccess = { userAccount in
            UserAccountManager.setUserAccount(account: userAccount)
            
            // Go Back to root
            for controller in self.mainNavigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.mainNavigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            
            // Update Drawer items
            self.items[0].items.removeAll(where: { item in
                item.title == "Sign In"
            })
            self.items[0].items.insert(SideMenuItem(title: "Favourites", image: UIImage(systemName: "star")!, onClick: self.openFavourites), at: 0)
            self.items[0].items.insert(SideMenuItem(title: "Sign Out", image: UIImage(systemName: "person")!, onClick: self.signOut), at: 0)
            self.tableView.reloadData()
        }
        self.dismiss(animated: true, completion: {
            self.mainNavigationController.pushViewController(vc, animated: true)
        })
    }
    
    
    private func signOut() {
        UserAccountManager.resetUserAccount()
        items[0].items.removeAll(where: { item in
            item.title == "Sign Out" || item.title == "Favourites"
        })
        items[0].items.insert(SideMenuItem(title: "Sign In", image: UIImage(systemName: "person")!, onClick: signIn), at: 0)
        tableView.reloadData()
    }
    
    
    private func openFavourites() {
        let vc = storyboard?.instantiateViewController(identifier: "FavouritesStoryboard") as! FavouritesViewController
        self.dismiss(animated: true, completion: {
            self.mainNavigationController.pushViewController(vc, animated: true)
        })
    }
    
    
    private func emailVendor() {
        let mailtoString = "mailto:\(GeneralInfoManager.getGeneralInfo()!.Vendor_Email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoUrl = URL(string: mailtoString!)!
        if UIApplication.shared.canOpenURL(mailtoUrl) {
            UIApplication.shared.open(mailtoUrl, options: [:])
        }
    }
    
    
    private func dialNumber() {
        if let url = NSURL(string: "tel://\(GeneralInfoManager.getGeneralInfo()!.phoneNumber!)"), UIApplication.shared.canOpenURL(url as URL) {
          UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    private func openFacebook() {
        if let account = GeneralInfoManager.getGeneralInfo()!.Social_Media.Vendor_Accounts.first(where: {
            $0.name == "facebook"
        }) {
            let websiteLink = account.Link
            let mobileLink = "fb://profile/\(websiteLink.replacingOccurrences(of: "https://www.facebook.com/", with: ""))"
            UIApplication.tryURL(urls: [
                mobileLink, // App
                websiteLink // Website if app fails
            ])
        }
        
    }
    
    
    private func openInstagram() {
        if let account = GeneralInfoManager.getGeneralInfo()!.Social_Media.Vendor_Accounts.first(where: {
            $0.name == "instagram"
        }) {
            let websiteLink = account.Link
            let mobileLink = "instagram://user?username=\(websiteLink.replacingOccurrences(of: "https://www.facebook.com/", with: ""))"
            UIApplication.tryURL(urls: [
                mobileLink, // App
                websiteLink // Website if app fails
            ])
        }
    }
    
    
    private func openTwitter() {
        if let account = GeneralInfoManager.getGeneralInfo()!.Social_Media.Vendor_Accounts.first(where: {
            $0.name == "twitter"
        }) {
            let websiteLink = account.Link
            let mobileLink = "twitter://user?screen_name=\(websiteLink.replacingOccurrences(of: "https://www.facebook.com/", with: ""))"
            UIApplication.tryURL(urls: [
                mobileLink, // App
                websiteLink // Website if app fails
            ])
        }
    }
    
    
    private func openUrl(_url: String) {
        if let url = URL(string: _url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    private func shareApp() {
        let firstActivityItem = "Check out this app for \(RestaurantInfoManager.name)"

            // Setting url
        let secondActivityItem : NSURL = NSURL(string: "http://your-url.com/")!
        
        // If you want to use an image
        let image : UIImage = UIImage(named: "logo")!
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
        UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
