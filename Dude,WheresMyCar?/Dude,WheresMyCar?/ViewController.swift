//
//  ViewController.swift
//  Dude,WheresMyCar?
//
//  Created by Jorge Catalan on 5/16/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//
import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    weak var appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let mapRegionRadius: CLLocationDistance = 500

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dude, wheres my car?"
        LocationAuthorization()
        
        let storedLocation = retrieveLocation()
        
        if let storedLocation = storedLocation {
            mapView.addAnnotation(storedLocation)
            centerMapOnLocation(storedLocation)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func getCurrentLocation(sender: UIBarButtonItem) {
        locationManager.startUpdatingLocation()
        guard let mapViewUserLocation = mapView.userLocation.location else {
            locationManager.stopUpdatingLocation()
            return
        }
        
        let currentLocation: Location = Location(coordinate: CLLocationCoordinate2DMake(mapViewUserLocation.coordinate.latitude, mapViewUserLocation.coordinate.longitude), title: "Current Location", subtitle: "")
        mapView.addAnnotation(currentLocation)
        centerMapOnLocation(currentLocation)
        saveLocation(currentLocation)
        locationManager.stopUpdatingLocation()
    }
    

    
    func LocationAuthorization() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: Location) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, mapRegionRadius * 2.0, mapRegionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    

    
    func saveLocation(location: Location) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(location)
        appDelegate?.defaults.setObject(data, forKey: "storedLocation")
    }
    
    func retrieveLocation() -> Location? {
        if let storedLocationData = appDelegate?.defaults.objectForKey("storedLocation") as? NSData {
            let storedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(storedLocationData)
            guard let coordinate = storedLocation?.coordinate, let title = storedLocation?.title, let subtitle = storedLocation?.subtitle else {
                return nil
            }
            
            return Location(coordinate: coordinate, title: title, subtitle: subtitle)
        }
        
        return nil
    }
    
}
