//
//  CheckoutViewController.swift
//  Chicken On Fire
//
//  Created by user on 18/11/2021.
//

import UIKit
import MapKit
import GoogleMaps
import NicoProgress

class CheckoutViewController: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressErrorLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var scheduleLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finalOrderTableView: UITableView!
    @IBOutlet weak var finalOrderTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cutleryCheckbox: UIButton!
    @IBOutlet weak var leaveAtDoorCheckbox: UIButton!
    @IBOutlet weak var specialRequestField: UITextField!
    @IBOutlet weak var deliveryRadioButton: UIButton!
    @IBOutlet weak var pickupRadioButton: UIButton!
    @IBOutlet weak var creditCardView: UIStackView!
    @IBOutlet weak var knetView: UIStackView!
    @IBOutlet weak var cashonDeliveryView: UIStackView!
    @IBOutlet weak var creditRadioButton: UIButton!
    @IBOutlet weak var knetRadioButton: UIButton!
    @IBOutlet weak var cashonDeliveryRadioButton: UIButton!
    @IBOutlet weak var voucherView: UIView!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var voucherLabel: UILabel!
    @IBOutlet weak var voucherDiscountLabel: UILabel!
    @IBOutlet weak var serviceChargeView: UIStackView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var grandtotalLabel: UILabel!
    @IBOutlet weak var placeOrderButton: CustomButton!
    @IBOutlet weak var progressView: NicoProgressBar!
    
    // Address Variables
    var address: Address! { didSet { checkIfValid() } }
    
    // Schedule Variables
    var schedule: Date? { didSet { checkIfValid() } }
    var scheduleValid = false { didSet { checkIfValid() } }
    var scheduleLoading = false {
        didSet {
            scheduleLoadingIndicator.isHidden = !scheduleLoading
            scheduleButton.isHidden = scheduleLoading
        }
    }
    
    // Cutlery and Leave order at door...
    var noCutlery = false
    var leaveOrderAtDoor = false
    
    // Delivery Method...
    var orderMethod = OrderMethod.delivery
    
    // Payment Method...
    var paymentMethod = PaymentMethod.unkown { didSet { checkIfValid() } }
    
    // Voucher ...
    var voucherID = ""
    
    // Payment Summary
    var subtotal: Double = 0
    var voucherDiscount: Double = 0
    var serviceCharge: Double = 0
    var grandTotal: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing UI...
        setAddress()
        addressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLocationCardTap(_:))))
        creditCardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(creditPaymentMethod(_:))))
        knetView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(knetPaymentMethod(_:))))
        cashonDeliveryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cashPaymentMethod(_:))))
        voucherView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentVoucher(_:))))
        
        updateSummary()
        getServiceCharge()
        
        
        // Initializing Final Order Table...
        finalOrderTableView.register(FinalOrderCell.nib(), forCellReuseIdentifier: FinalOrderCell.identifier)
        finalOrderTableView.delegate = self
        finalOrderTableView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        finalOrderTableViewHeight.constant = finalOrderTableView.contentSize.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Schedule Segue...
        if segue.identifier == "ScheduleSegue" {
            let vc = segue.destination as! ScheduleViewController
            vc.selectedDate = schedule
            vc.onSchedulePicked = { date in
                self.scheduleLoading = true
                ScheduleOrder.checkIfValid(branchId: GeneralAreaManager.getSavedArea().branchID, schedule: date, onSuccess: { valid in
                    
                    DispatchQueue.main.async {
                        if valid {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "Y-MM-dd HH:MM:SS"
                            let stringDate = formatter.string(from: date)
                            self.scheduleLabel.text = stringDate
                            self.scheduleLabel.textColor = .gray
                        } else {
                            self.scheduleLabel.text = "Sorry, we will not be availalbe at this time"
                            self.scheduleLabel.textColor = .red
                        }
                        self.scheduleValid = valid
                        self.schedule = date
                        self.scheduleLabel.isHidden = false
                        
                        self.scheduleLoading = false
                    }
                    
                }, onFailure: { error in
                    DispatchQueue.main.async {
                        print(error)
                        self.scheduleLoading = false
                        self.scheduleLabel.isHidden = true
                    }
                })
            }
            vc.onScheduleRemoved = {
                self.schedule = nil
                self.scheduleLabel.isHidden = true
            }
        }
    }
    
    
    func setAddress() -> Void {
        let address = UserAddressManager.userAddresses.last!
        self.address = address
        
        if address.branchId != GeneralAreaManager.getSavedArea().branchID {
            addressErrorLabel.isHidden = false
        } else {
            addressErrorLabel.isHidden = true
        }
        
        setupAddressCard()
        getServiceCharge()
    }
    
    private func setupMap() -> Void {
        let selectedCoordinates = address.getCoordinates()
        let camera = GMSCameraPosition(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude, zoom: 15)
        mapView.camera = camera
        
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        
    }
    
    private func setupAddressCard() {
        setupMap()
        
        areaLabel.text = address.area
        var addressText = "Block \(address.block), Street \(address.street)"
        if address.addressType == .house {
            addressText += ", House \(address.house)"
        } else if address.addressType == .aparatment {
            addressText += ", Building \(address.building)"
        } else {
            addressText += ", Office \(address.office)"
        }
        addressLabel.text = addressText
        mobileLabel.text = "Mobile: \(address.phoneCode) \(address.phoneNumber)"
    }
    
    
    private func getServiceCharge() {
        ServiceChargeApi.getServiceFee(branchId: GeneralAreaManager.getSavedArea().branchID, latitude: address.getCoordinates().latitude, longitude: address.getCoordinates().longitude, onSuccess: { serviceCharge in
            
            DispatchQueue.main.async {
                self.serviceChargeLabel.text = "\(String(format: "%.3f", serviceCharge)) K.D"
                self.serviceChargeView.isHidden = false
                self.serviceCharge = serviceCharge
                self.updateSummary()
            }
        }, onFailure: { error in
            print(error)
        })
    }
    
    private func updateSummary() {
        subtotal = 0
        for basketItem in BasketManager.basketItems {
            subtotal += basketItem.totalPrice
        }
        let discountedSubtotal = subtotal - (voucherDiscount/100 * subtotal)
        voucherDiscountLabel.text = "- \(String(format: "%.3f", voucherDiscount/100 * subtotal)) K.D"
        
        subtotalLabel.text = "\(String(format: "%.3f", subtotal)) K.D"
        
        grandTotal = serviceCharge + discountedSubtotal
        grandtotalLabel.text = "\(String(format: "%.3f", grandTotal)) K.D"
        
    }
    
    
    func showClosedAlert() {
        let status = GeneralInfoManager.getGeneralInfo()!.status == "CLOSED" ? "Closed" : "Busy"
        let alert = UIAlertController(title: "Restaurant \(status)", message: "Sorry, but the restaurant is currently \(status.lowercased()). Make sure to come back later!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func checkIfValid() {
        var valid = true
        if paymentMethod == .unkown {
            valid = false
        }
        if address.branchId != GeneralAreaManager.getSavedArea().branchID {
            valid = false
        }
        if schedule != nil && scheduleValid == false {
            valid = false
        }
        if paymentMethod == .cashOnDelivery && schedule != nil && !GeneralInfoManager.getGeneralInfo()!.Enable_CodAndSchedule {
            valid = false
        }
        placeOrderButton.active = valid
        placeOrderButton.isEnabled = valid
    }
    
    private func getScheduleString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "Y-MM-dd HH:MM:SS"
        
        if schedule != nil {
            return formatter.string(from: schedule!)
        }else{
            return ""
        }
    }
    
    
    func getPaymentMethodString() -> String {
        switch paymentMethod {
        case .knet:
            return "KNET"
        case .creditCard:
            return "Credit Card"
        default:
            return "Cash on delivery"
        }
    }
    
    
    func isPickup() -> Bool {
        return orderMethod == .pickup
    }
      
    
    private func getOrder() -> Order {
        // Getting User Info...
        let userInfo = UserInfo (address: address, email: UserAccountManager.savedUserAccount().email)
        
        // Getting Order Info...
        var orderedItems = [OrderItem]()
        for basketItem in BasketManager.basketItems {
            var customizations = [Customization]()
            for addon in basketItem.addons {
                let customization = Customization(nm: addon.name, nmL: addon.nameAr, pr: addon.price)
                customizations.append(customization)
            }
            
            let orderedItem = OrderItem(menuItemID: basketItem.itemID, specialRequest: basketItem.specialRequest, quantity: basketItem.quantity, customization: customizations)
            orderedItems.append(orderedItem)
        }
        
        let orderInfo = OrderInfo(orderedItems: orderedItems, schedule: getScheduleString(), cutlery: noCutlery, Leave_order_at_the_door: leaveOrderAtDoor, subtotal: subtotal, specialRequest: specialRequestField.text!)
        
        let order = Order(userInfo: userInfo, orderInfo: orderInfo, paymentMethod: getPaymentMethodString(), serviceFee: serviceCharge, voucherID: voucherID, pickUp: isPickup(), brID: GeneralAreaManager.getSavedArea().branchID)
        
        return order
    }
    
    
    private func sendOrder(order: Order) {
        progressView.isHidden = false
        OrderApi.sendOrder(order: getOrder(), onSuccess: {
            DispatchQueue.main.async {
                BasketManager.clearBasket()
                self.progressView.isHidden = true
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: HomeViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        (controller as! HomeViewController).showSuccessAlert()
                        break
                    }
                }
            }
            
        }, onFailure: { error in
            print(error)
            self.progressView.isHidden = true
        })
        
    }

    @IBAction func goBack(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: BasketViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func checkCutlery(_ sender: Any) {
        noCutlery = !noCutlery
        if noCutlery {
            cutleryCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            cutleryCheckbox.tintColor = UIColor(named: "accentColor")
        } else {
            cutleryCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
            cutleryCheckbox.tintColor = .black
        }
    }
    
    
    @IBAction func checkLeaveOrderAtDoor(_ sender: Any) {
        leaveOrderAtDoor = !leaveOrderAtDoor
        if leaveOrderAtDoor {
            leaveAtDoorCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            leaveAtDoorCheckbox.tintColor = UIColor(named: "accentColor")
        } else {
            leaveAtDoorCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
            leaveAtDoorCheckbox.tintColor = .black
        }
    }
    
    @IBAction func deliveryDeliveryMethod(_ sender: Any) {
        deliveryRadioButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        deliveryRadioButton.tintColor = UIColor(named: "accentColor")
        pickupRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        pickupRadioButton.tintColor = .black
        orderMethod = .delivery
    }
    
    
    @IBAction func submitOrder(_ sender: Any) {
        // If restuarant is closed...
        if GeneralInfoManager.getGeneralInfo()!.status == "CLOSED" || GeneralInfoManager.getGeneralInfo()!.status == "BUSY" {
            showClosedAlert()
            return
        }
        
        let phoneVerificationEnabled = GeneralInfoManager.getGeneralInfo()!.Enable_Phone_Verification
        if phoneVerificationEnabled {
            let verified = PhoneVerificationManager.phoneNumbers.contains(where: {
                $0.phoneNumber == address.phoneNumber && $0.phoneCode == address.phoneCode
            })
            
            if !verified {
                let vc = storyboard?.instantiateViewController(identifier: "PhoneVerificationStoryboard") as! PhoneVerificationViewController
                vc.phoneNumber = address.phoneNumber
                vc.phoneCode = address.phoneCode
                vc.onSuccess = {
                    self.submitOrder(self)
                }
                present(vc, animated: true, completion: nil)
                return
            }
        }
        
        if paymentMethod == .cashOnDelivery {
            sendOrder(order: getOrder())
        } else {
            
            progressView.isHidden = false
            PaymentApi.getPayUrl(paymentMethod: paymentMethod, total: grandTotal, onSuccess: { payurl in
                DispatchQueue.main.async {
                    let bookeyVC = self.storyboard?.instantiateViewController(identifier: "BookeyStoryboard") as! BookeyViewController
                    bookeyVC.request = URLRequest(url: URL(string: payurl)!)
                    bookeyVC.onSuccess = {
                        self.sendOrder(order: self.getOrder())
                    }
                    self.present(bookeyVC, animated: true, completion: nil)
                    self.progressView.isHidden = true
                }
            }, onFailure: { error in
                print(error)
                self.progressView.isHidden = true
            })
        }
        
    }
    
    
    @IBAction func pickupDeliveryMethod(_ sender: Any) {
        pickupRadioButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        pickupRadioButton.tintColor = UIColor(named: "accentColor")
        deliveryRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        deliveryRadioButton.tintColor = .black
        orderMethod = .pickup
    }
    
    
    @objc func creditPaymentMethod(_ sender: Any) {
        creditRadioButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        creditRadioButton.tintColor = UIColor(named: "accentColor")
        knetRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        knetRadioButton.tintColor = .black
        cashonDeliveryRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        cashonDeliveryRadioButton.tintColor = .black
        paymentMethod = .creditCard
    }
    
    
    @objc func knetPaymentMethod(_ sender: Any) {
        knetRadioButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        knetRadioButton.tintColor = UIColor(named: "accentColor")
        creditRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        creditRadioButton.tintColor = .black
        cashonDeliveryRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        cashonDeliveryRadioButton.tintColor = .black
        paymentMethod = .knet
    }
    
    
    @objc func cashPaymentMethod(_ sender: Any) {
        cashonDeliveryRadioButton.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        cashonDeliveryRadioButton.tintColor = UIColor(named: "accentColor")
        knetRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        knetRadioButton.tintColor = .black
        creditRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        creditRadioButton.tintColor = .black
        paymentMethod = .cashOnDelivery
    }
    
    
    @objc func onLocationCardTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AddLocation") as! AddLocationViewController
        vc.address = address
        vc.onAddAddress = {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: CheckoutViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
            self.setAddress()
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc func presentVoucher(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "Voucher") as! VoucherViewController
        vc.onVoucherAdded = { (vid, discount) in
            self.voucherID = vid
            self.voucherDiscount = discount
            self.voucherImage.isHidden = true
            self.voucherLabel.text = "Voucher discount"
            self.voucherLabel.textColor = .green
            self.voucherDiscountLabel.isHidden = false
            self.voucherDiscountLabel.textColor = .green
            self.voucherView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 255, blue: 0, alpha: 0.1))
            
            self.updateSummary()
        }
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
}


extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BasketManager.basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FinalOrderCell.identifier, for: indexPath) as! FinalOrderCell
        cell.configure(basketItem: BasketManager.basketItems[indexPath.row])
        return cell
    }
    
    
}
