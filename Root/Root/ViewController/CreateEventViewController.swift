//
//  CreateEventViewController.swift
//  Root
//
//  Created by Edmund Bollenbacher on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var eventPictureImageView: UIImageView!
    @IBOutlet weak var nameOfArtistLabel: UILabel!
    @IBOutlet weak var titleOfEventTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var timeDateTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()

        // Do any additional setup after loading the view.
    }

    @IBAction func paintButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func poetryButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func ceramicButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
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
