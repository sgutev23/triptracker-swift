//
//  AddTripViewController.swift
//  TripTracker
//
//  Created by Stan Gutev on 10/8/16.
//  Copyright © 2016 Stanislav Gutev. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class AddTripViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var tripTitle : String!
    var rootRef = FIRDatabaseReference()
    let user = FIRAuth.auth()?.currentUser
    var tripRef = FIRDatabaseReference()
    
    var manager : CLLocationManager = CLLocationManager()
    var coordinates = [CLLocationCoordinate2D]()
    var oldPolyline : MKPolyline!
    var newPolyline : MKPolyline!
    var userMoved : Bool = false;
    
    var timer : Timer!
    
    var isRunning : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tripTitle
        
        setUpMapShit()
        setUpNewTrip()
        
//        timer = Timer.scheduledTimer(timeInterval: 5,
//                      target: self,
//                      selector: #selector(self.timerFired(_:)),
//                      userInfo: nil,
//                      repeats: true)
        
    }
    
    func setUpMapShit() {
        mapView.layer.borderWidth = 0.7
        mapView.layer.masksToBounds = false
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        manager.delegate = self
        mapView.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(gestureRecognizer:)))
        mapDragRecognizer.delegate = self
        self.mapView.addGestureRecognizer(mapDragRecognizer)
    }
    
    func setUpNewTrip() {
        rootRef = FIRDatabase.database().reference()
        let userRef = rootRef.child("users").child((user?.uid)!)
        tripRef = userRef.child("trips").childByAutoId()
        tripRef.child("name").setValue(tripTitle)
        tripRef.child("active").setValue(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        print("locations \(manager.desiredAccuracy)")
        print("locations \(locations.count)")
        print("locations = \(locations)");
        let userLoc : CLLocation = locations[0]
        
        let latitude : CLLocationDegrees = userLoc.coordinate.latitude
        let longitude : CLLocationDegrees = userLoc.coordinate.longitude
        
        let latDelta : CLLocationDegrees = 0.1
        let lonDelta : CLLocationDegrees = 0.1
        
        // makes a range
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        // makes a location coordinate
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        if (!userMoved) {
            mapView.setRegion(region, animated: true)
        }
        
        //locations.append(CLLocation(latitude: latitude, longitude: longitude))
       
        if (isRunning) {
            
            let coordinatesEntry = [
                "latitude": latitude,
                "longitude": longitude
            ]
            let coordinatesRef = tripRef.child("coordinates").childByAutoId()
            coordinatesRef.setValue(coordinatesEntry);
            
            coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            newPolyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            mapView.add(newPolyline)
            if (oldPolyline != nil) {
                mapView.remove(oldPolyline)
            }
            oldPolyline = newPolyline
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor(red: 240/255, green: 95/255, blue: 65/255, alpha: 1)
        polylineRenderer.lineWidth = 10
        return polylineRenderer
        
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            print("Map drag began")
            userMoved = true;
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            print("Map drag ended")
        }
    }
    
    func timerFired (_ timer: Timer) {
        print("request now")
        manager.requestLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // timer.invalidate()
    }
    

    @IBOutlet weak var startPauseTripButton: UIButton!
    
    @IBAction func startPauseTrip(_ sender: AnyObject) {
        if (isRunning) {
            manager.stopUpdatingLocation()
            isRunning = false;
            startPauseTripButton.setTitle("START", for: UIControlState.normal)
            startPauseTripButton.setTitleColor(UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1), for: UIControlState.normal)
        } else {
            manager.startUpdatingLocation()
            isRunning = true;
            startPauseTripButton.setTitle("PAUSE", for: UIControlState.normal)
            startPauseTripButton.setTitleColor(UIColor(red: 255/255, green: 204/255, blue: 102/255, alpha: 1), for: UIControlState.normal)
        }
    }
    
    @IBAction func stopTrip(_ sender: AnyObject) {
        manager.stopUpdatingLocation()
        isRunning = false;
    }
}

