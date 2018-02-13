//
//  AgreementViewController.swift
//  Root
//
//  Created by Frank Martin Jr on 1/25/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class AgreementViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(scrollView.contentOffset)
        print(scrollView.contentInset)
        scrollView.setContentOffset(CGPoint(x: 150, y: 100), animated: true)
        scrollView.contentOffset = CGPoint(x: 200, y: 200)
        print(scrollView.contentOffset)
        print(scrollView.contentInset)
    }
    
    @IBAction func agreeButtonTapped(_ sender: UIButtonX) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func declineButtonTapped(_ sender: UIButtonX) {
        self.licenseDeclinedAlert()
    }

}
