//
//  VoucherManager.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation

struct Voucher: Codable {
    var voucherID: String
    var discountValue: Double
}


enum VoucherStatus {
    case valid
    case invalid
    case unkown
}
