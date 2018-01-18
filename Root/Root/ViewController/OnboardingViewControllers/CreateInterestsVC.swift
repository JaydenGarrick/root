//
//  CreateInterestsVC.swift
//  Root
//
//  Created by Frank Martin Jr on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

class CreateInterestsVC: UIViewController {

    // MARK: - Properties
    var isArtist: Bool?
    var fullName: String?
    var username: String?
    var hometown: String?
    
    var interests: [String] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var interestsTextView: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func paintButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#paintings") {
            return
        }
        self.interests.append("#paintings")
        updateInterestsTextView()
    }
    
    @IBAction func musicButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#music") {
            return
        }
        
        self.interests.append("#music")
        updateInterestsTextView()
    }
    @IBAction func photographyButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#photography") {
            return
        }
        self.interests.append("#photography")
        updateInterestsTextView()
    }
    @IBAction func poetryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#poetry") {
            return
        }
        interests.append("#poetry")
        updateInterestsTextView()
    }
    @IBAction func sketchButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#sketch") {
            return
        }
        interests.append("#sketch")
        updateInterestsTextView()
    }
    @IBAction func potteryButtonTapped(_ sender: UIButton) {
        if self.interests.contains("#pottery") {
            return
        }
        interests.append("#pottery")
        updateInterestsTextView()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.dismissKeyboard()
     
        setUserLabel()
    
    }
    
    func setUserLabel() {
        guard let isArtist = self.isArtist
            else { return }
        if isArtist == true {
            userLabel?.text = "Creator"
        }
        else if isArtist == false {
            userLabel?.text = "Art Seeker"
        }
    }
    
    func updateInterestsTextView() {
        var textFieldText: String = ""
        for interest in self.interests {
            textFieldText += " \(interest)"
        }
        interestsTextView.text = textFieldText
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToCreateProfPicSegue" {
            guard let destinationVC = segue.destination as? CreateProfPicVC
                else { return }
            
            destinationVC.isArtist = self.isArtist
            destinationVC.fullName = self.fullName
            destinationVC.username = self.username
            destinationVC.hometown = self.hometown
            destinationVC.interests = self.interests
            
        }
    }
    

}
