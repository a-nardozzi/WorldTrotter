//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Alexander Nardozzi on 2/7/17.
//  Copyright © 2017 Alex Nardozzi. All rights reserved.
//


import UIKit
import WebKit


class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
        
    }
    
}
