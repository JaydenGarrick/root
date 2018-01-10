//
//  MapFeedViewController.swift
//  Root
//
//  Created by Jayden Garrick on 1/10/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import MapKit

class MapFeedViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Location Manager
    let locationManager = CLLocationManager()
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CoreLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // MapKit
        mapView.delegate = self

        
        
    }

   
    

    
    
    
    
    
    
    
    // IBActions
    @IBAction func localFeedInterestFeedToggled(_ sender: Any) {
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
