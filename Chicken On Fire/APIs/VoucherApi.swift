//
//  VoucherApi.swift
//  Chicken On Fire
//
//  Created by user on 28/09/2021.
//

import Foundation

class VoucherApi {
    static func useVoucher(voucherID: String, onSuccess: ((VoucherStatus, Double) -> Void)?, onFailure: ((String) -> Void)?){
        guard let url = URL(string: RestaurantInfoManager.backendURL + "/mobile-api/get-vouchers/") else {
            onFailure?("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue(RestaurantInfoManager.apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Array<Voucher>.self, from: data) {
                    DispatchQueue.main.async {
                        let vouchers = decodedResponse
                        for voucher in vouchers{
                            if voucherID == voucher.voucherID {
                                onSuccess?(.valid, voucher.discountValue)
                                return
                            }

                        }
                        onSuccess?(.invalid, 0)
                        return
                        
                    }
                } else {
                    onFailure?("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            } else {
                onFailure?("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            
        }.resume()
    }
}
