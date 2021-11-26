//
//  BookeyViewController.swift
//  Chicken On Fire
//
//  Created by user on 20/11/2021.
//

import UIKit
import WebKit

class BookeyViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var request: URLRequest?
    var onSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let request = request else { return }
        
        webView.navigationDelegate = self
        webView.load(request)
        
    }
    
}


extension BookeyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url?.absoluteString ?? ""
        if url.contains("paymentSuccess") {
            onSuccess?()
            dismiss(animated: true, completion: nil)
        }
    }
}
