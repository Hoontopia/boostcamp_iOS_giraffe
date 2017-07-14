//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by 임성훈 on 2017. 7. 7..
//  Copyright © 2017년 임성훈. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var webView: UIWebView!
    
    override func viewDidLoad() {
        webView = UIWebView()
        view = webView
        
        // 디폴트 페이지 설정
        if let defaultURL: URL = URL(string: "https://www.bignerdranch.com") {
        let urlRequest: URLRequest = URLRequest(url: defaultURL)
            webView.loadRequest(urlRequest)
        }
    }
}
