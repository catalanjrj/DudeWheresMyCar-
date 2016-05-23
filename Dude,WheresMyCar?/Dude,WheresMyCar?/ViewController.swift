//
//  ViewController.swift
//  Dude,WheresMyCar?
//
//  Created by Jorge Catalan on 5/16/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//
import MapKit
import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate, UIPopoverPresentationControllerDelegate,PopoverLocationViewControllerDelegate
{
    
    @IBOutlet var dudeHeresTheMap: MKMapView!

    @IBOutlet weak var mapView: MKMapView!
    
    
    var locationName:String = " "
    let locationManager = CLLocationManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dude, Here's The Map!"
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dudeDropAPin(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showPopover", sender: self)
        
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPopover" {
            
            let viewCont = segue.destinationViewController as? PopoverLocationViewController
            viewCont?.delegate = self
            
        }
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Location status changed")
    }
    
    // Did Fail With Error
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    
    // Did Update Location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        
        let center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
    }
    
    
    func setCarLocationName(carLocationName: String) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        // self.navigationController?.popViewControllerAnimated(true)
        
        locationName = carLocationName
        
        // Drop pin on map at current location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        annotation.title = carLocationName
        self.mapView.addAnnotation(annotation)
        
        // Save this location to NSUserDefaults
        
        // We have our coordinates stored in annotation.coordinate
        let carLat = NSNumber(double: annotation.coordinate.latitude)
        let carLon = NSNumber(double: annotation.coordinate.longitude)
        
        let locationDict = ["name": locationName, "lat": carLat, "long": carLon]
        // let locationDict = ["lat": carLat, "long": carLon]
        NSUserDefaults.standardUserDefaults().setObject(locationDict, forKey: "CarLocation")
        // NSCoding
    //savingCar
    func dudeRememberTheCar() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(locationDict, toFile: Car.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Could not Save")
        }
    }

}


}