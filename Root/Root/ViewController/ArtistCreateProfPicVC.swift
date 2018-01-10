//
//  ArtistCreateProfPicVC.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class ArtistCreateProfPicVC: UIViewController, UIImagePickerControllerDelegate {

    // MARK: - Properties
    
    var isArtist: Bool?
    var fullName: String?
    var username: String?
    var hometown: String?
    var interests: [String]?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var websiteURLTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func addProfPictButtonTapped(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
//        pickerController.
        
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        <#code#>
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
