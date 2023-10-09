//
//  MapsViewController.swift
//  communityaerial
//
//  Created by Lisette HG on 08/10/23.
//

import UIKit
import WebKit

class MapsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self
        
        if let url = URL(string: "https://firms.modaps.eosdis.nasa.gov/map/#d:today;@0.0,0.0,3.0z") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }



}
