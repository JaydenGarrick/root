//
//  WebViewController.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/18/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var websiteURLAsString: String?
    
    @IBOutlet weak var urlLinkWebView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let websiteURLAsString = websiteURLAsString else { return }
        guard let url = URL(string: websiteURLAsString) else { return }
        let request = URLRequest(url: url)
        urlLinkWebView.load(request)

    }


 

}
