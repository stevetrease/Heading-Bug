//
//  ViewController.swift
//  Heading Bug
//
//  Created by Steve on 19/02/2019.
//  Copyright © 2019 Steve. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var currentLatLongLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var compassView: CompassView!
    
    @IBOutlet var tableView: UITableView!
    
    var locationManager:CLLocationManager!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentLatLongLabel.text = ""
        currentLocationLabel.text = ""
        
        wayPointManager.createInitialWayPoints ()
        print (wayPointManager.getWayPointCount(), "waypoints added")
        
        determineMyCurrentLocation()
        
        refreshSortAndFilterData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wayPointManager.getWayPointCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WayPointListCell")!
        
        cell.textLabel?.text = wayPointManager.getWayPoint(item: indexPath.row).name
        
        // let distanceInMeters = Measurement(value: wayPointManager.wayPointDistance(item: indexPath.row, from: currentLocation), unit: UnitLength.meters)
        let distanceInMeters = Measurement(value: wayPointManager.getWayPoint(item: indexPath.row).distance, unit: UnitLength.meters)
        let distanceFormatter = MeasurementFormatter()
        distanceFormatter.unitStyle = .medium
        distanceFormatter.numberFormatter.maximumFractionDigits = 1
        distanceFormatter.numberFormatter.minimumFractionDigits = 1
        let distanceString = distanceFormatter.string(from: distanceInMeters)
        
        // let bearing = wayPointManager.wayPointBearing(item: indexPath.row, from: currentLocation)
        let bearing = wayPointManager.getWayPoint(item: indexPath.row).bearing
        let bearingFormatter = NumberFormatter()
        bearingFormatter.maximumFractionDigits = 0
        bearingFormatter.minimumFractionDigits = 0
        let bearingString = bearingFormatter.string(from: NSNumber(value: bearing))
        
        cell.detailTextLabel?.text = distanceString + " at " + bearingString! + "°"
        
        return cell
    }
    
    
    func determineMyCurrentLocation() {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        // print ("heading: \(newHeading)")
        compassView.heading = newHeading.trueHeading
    }
    
    
    func locationManager (_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        // print("user latitude = \(userLocation.coordinate.latitude)")
        // print("user longitude = \(userLocation.coordinate.longitude)")
        
        currentLocation = CLLocationCoordinate2D (latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(userLocation, preferredLocale: nil, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                
                var tempString = ""
                if (firstLocation?.subLocality != nil) {
                    tempString = tempString + (firstLocation?.subLocality)!
                }
                if (firstLocation?.locality != nil) {
                    if tempString != "" {
                        tempString = tempString + "\n"
                    }
                    tempString = tempString + (firstLocation?.locality)!
                }
                if (firstLocation?.country != nil) {
                    if tempString != "" {
                        tempString = tempString + "\n"
                    }
                    tempString = tempString + (firstLocation?.country)!
                }
                // print (tempString)
                
                OperationQueue.main.addOperation {
                    self.currentLocationLabel.text = tempString
                }
            }
            return
        })
            
        refreshSortAndFilterData()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    @objc func refreshSortAndFilterData () {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.minimumFractionDigits = 3
        
        let latString = numberFormatter.string(from: NSNumber(value: currentLocation.latitude))
        let longString = numberFormatter.string(from: NSNumber(value: currentLocation.longitude))
        
        currentLatLongLabel.alpha = 0.7
        currentLatLongLabel.text = latString! + "\n" + longString!
        UIView.animate(withDuration: 0.5, animations: {
            self.currentLatLongLabel.alpha = 1.0
        })
        
        tableView.reloadData()
    }
    
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        let location = sender.location(in: view)
        // User tapped at the point above. Do something with that if you want.
        tableView.reloadData()
    }
}

