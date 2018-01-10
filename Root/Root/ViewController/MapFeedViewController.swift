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
        mapView.showAnnotations(annotations, animated: true)
        
        

        
       
       
    }

   
    

    
    
    
    
    
    
    
    // IBActions
    @IBAction func localFeedInterestFeedToggled(_ sender: Any) {
    }
    
    
    
    // MARK: - Mapkit Delegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationID")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationID")
            view.canShowCallout = true
        }
        
        let detailViewButton = UIButton()
        detailViewButton.backgroundColor = .black
        view.canShowCallout = true
        view.rightCalloutAccessoryView = detailViewButton
        view.annotation = annotation
        
        return view
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

extension MapFeedViewController {
    
    var annotations: [MKPointAnnotation] {
        
        let devMtnPin = MKPointAnnotation()
        let coordinate1 = CLLocationCoordinate2D(latitude: 40.761836, longitude: -111.890746)
        devMtnPin.coordinate = coordinate1
        devMtnPin.title = "DevMountain"
        devMtnPin.subtitle = "Where Joe is the best mentor there ever was"
        
        
        let kilbyCourtPin = MKPointAnnotation()
        let coordinate2 = CLLocationCoordinate2D(latitude: 40.752619, longitude: -111.901073)
        kilbyCourtPin.coordinate = coordinate2
        kilbyCourtPin.title = "Kilby Court"
        kilbyCourtPin.subtitle = "Place where sometimes a good band plays"

        let theDepotPin = MKPointAnnotation()
        let coordinate3 = CLLocationCoordinate2D(latitude: 40.769652, longitude: -111.903051)
        theDepotPin.coordinate = coordinate3
        theDepotPin.title = "The Depot"
        theDepotPin.subtitle = "suh"
        
        
        
     
    
        return [devMtnPin, kilbyCourtPin, theDepotPin]
    }
    
    
}

















