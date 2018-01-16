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
    var eventToPass: Event?
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Customizing Navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        if UserController.shared.loggedInUser?.isArtist == false {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        // CoreLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // MapKit
        mapView.delegate = self
        mapView.showAnnotations(EventController.shared.fetchedEvents, animated: true)

    }

    // MARK: - IBActions
    @IBAction func localFeedInterestFeedToggled(_ sender: Any) {
    }
    
    
    
    // MARK: - Mapkit Delegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Event else { return nil }
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationID")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationID")
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        let detailViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 59, height: 59))
        detailViewButton.setImage(#imageLiteral(resourceName: "calendar"), for: .normal)
        
        view.canShowCallout = true
        view.rightCalloutAccessoryView = detailViewButton
        view.annotation = annotation
       
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let event = view.annotation as? Event {
                
                self.eventToPass = event
                print(eventToPass?.name)
                performSegue(withIdentifier: "MapFeedSegue", sender: self)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapFeedSegue" {
            let destinationVC = segue.destination as? EventDetailTableViewController
            destinationVC?.event = eventToPass
            
        }
    }
    
}


















