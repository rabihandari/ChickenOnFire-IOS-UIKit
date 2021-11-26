//
//  SelectAddressViewController.swift
//  Chicken On Fire
//
//  Created by user on 18/11/2021.
//

import UIKit

class SelectAddressViewController: UIViewController {
    
    @IBOutlet weak var addressesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressesTableView.register(AddressTableCell.nib(), forCellReuseIdentifier: AddressTableCell.identifier)
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.separatorColor = .clear
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAddressSegue" {
            let vc = segue.destination as! AddLocationViewController
            vc.onAddAddress = {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: SelectAddressViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                self.addressesTableView.reloadData()
            }
        }
    }

}


extension SelectAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserAddressManager.userAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableCell.identifier, for: indexPath) as! AddressTableCell
        let address = UserAddressManager.userAddresses[indexPath.row]
        cell.configure(address: address, hasDivider: indexPath.row != UserAddressManager.userAddresses.count - 1, enabled: address.branchId == GeneralAreaManager.getSavedArea().branchID)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let address = UserAddressManager.userAddresses.remove(at: indexPath.row)
        UserAddressManager.userAddresses.append(address)
        
        let vc = navigationController?.viewControllers.previous as! CheckoutViewController
        vc.setAddress()
        goBack(self)
    }
    
}
