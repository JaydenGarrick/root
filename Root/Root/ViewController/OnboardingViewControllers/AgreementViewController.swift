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
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: false)
    }
    
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
