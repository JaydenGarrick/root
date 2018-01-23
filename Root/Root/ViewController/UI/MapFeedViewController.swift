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
    var localFeed: Bool = true
    var interestArray: [Event] = []
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        print("\(EventController.shared.eventHappeningWithinTwentyFour.count) is the amount of events within 24hours")
        
        // Customizing Navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        setImageOnNavBar()
        
        // CoreLocation
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // MapKit
        mapView.delegate = self
        if localFeed == true {
            mapView.showAnnotations(EventController.shared.eventHappeningWithinTwentyFour, animated: true)
        } else {
            mapView.removeAnnotations(EventController.shared.eventHappeningWithinTwentyFour)
            mapView.showAnnotations(interestArray, animated: true)

        }

    }

    // MARK: - IBActions
   
    @IBAction func feedToggled(_ sender: UISegmentedControl) {
        interestArray = []
        if sender.selectedSegmentIndex == 1 {
            localFeed = false
            for event in EventController.shared.eventHappeningWithinTwentyFour {
                for interest in (UserController.shared.loggedInUser?.interests)! {
                    if event.typeOfEvent.trimmingCharacters(in: .whitespaces) == interest {
                        if interestArray.isEmpty {
                            interestArray.append(event)
                        } else {
                            for interestEvent in interestArray {
                                if event.name != interestEvent.name {
                                    interestArray.append(event)
                                }
                            }
                        }
                       
                        print(interestArray.count)
                    }
                }
                mapView.removeAnnotations(EventController.shared.eventHappeningWithinTwentyFour)
                mapView.addAnnotations(interestArray)
            }
        } else {
            localFeed = true
           mapView.addAnnotations(EventController.shared.eventHappeningWithinTwentyFour)
        }
    }
    
    
    
    // MARK: - Mapkit Delegate functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Event else { return nil }
        
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationID")
        
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationID")
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        
        let detailViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 59, height: 59))
        detailViewButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        let event = view.annotation as? Event
        
        view.canShowCallout = true
        view.rightCalloutAccessoryView = detailViewButton
        //view.image = UIImage(named: event!.typeOfEvent.trimmingCharacters(in: .whitespaces))
        if event?.typeOfEvent == " #music" {
            view.image = #imageLiteral(resourceName: "AnnotationMusic")
        }
        if event?.typeOfEvent == " #sketch" {
            view.image = #imageLiteral(resourceName: "AnnotationSketch")
        }
        if event?.typeOfEvent == " #paintings" {
            view.image = #imageLiteral(resourceName: "AnnotationPaint")
        }
        if event?.typeOfEvent == " #photography" {
            view.image = #imageLiteral(resourceName: "AnnotationPhotog")
        }
        if event?.typeOfEvent == " #poetry" {
            view.image = #imageLiteral(resourceName: "AnnotationPoetry")
        }
        if event?.typeOfEvent == " #pottery" {
            view.image = #imageLiteral(resourceName: "AnnotationCeramic")
        }

        print("\(event!.typeOfEvent.trimmingCharacters(in: .whitespaces))")
        view.annotation = annotation
       
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            if let event = view.annotation as? Event {
                
                self.eventToPass = event
                print("\(String(describing: eventToPass?.name)) is the name of the event that is seguewaying")
                performSegue(withIdentifier: "MapFeedSegue", sender: self)
            }
        }
    }
 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapFeedSegue" {
            let destinationVC = segue.destination as? EventDetailViewController
            destinationVC?.event = eventToPass
            
        }
    }
    
}

extension MapFeedViewController {
    func setImageOnNavBar() {
        
        let navController = navigationController!
        
        let image = #imageLiteral(resourceName: "NavigationBarImage")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
    }
}


















