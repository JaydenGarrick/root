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
            //performSegue(withIdentifier: "MapFeed SegueWay", sender: view)
            print("Working!")
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapFeed SegueWay" {
//            let destinationVC = segue.destination as? EventDetailTableViewController
//            let annotationView = sender as? MKAnnotation
            
        }
    }
    
}


















