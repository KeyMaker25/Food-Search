//
//  RecipePageWebView.swift
//  VeganWay
//
//  Created by Oron Bernat on 10/07/2019.
//  Copyright © 2019 Bernat Investing. All rights reserved.
//

import UIKit
import WebKit

class RecipePageWebViewController: UIViewController {
    
    var link:String!
    @IBOutlet weak var webView: WKWebView!
    let backURL = URL(string: "https://www.supercook.com/#/recipes")!
    
    override func viewWillAppear(_ animated: Bool) {
        let URl = URL(string: link) ?? backURL
        let request = URLRequest(url: URl)
        webView?.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
}
