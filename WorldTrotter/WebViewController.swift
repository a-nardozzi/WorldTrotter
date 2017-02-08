//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Alexander Nardozzi on 2/7/17.
//  Copyright © 2017 Alex Nardozzi. All rights reserved.
//


import UIKit
import WebKit


class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "http://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
        
    }
    
}
