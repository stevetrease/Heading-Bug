//
//  ViewController.swift
//  Heading Bug
//
//  Created by Steve on 19/02/2019.
//  Copyright © 2019 Steve. All rights reserved.
//

import UIKit
import CoreLocation

var currentLocation = CLLocationCoordinate2D (latitude: 57.105, longitude: -2.089)




class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var currentLatLongLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var currentLocation = CLLocationCoordinate2D (latitude: 0, longitude:0)
    var locationManager:CLLocationManager!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var wayPoint = WayPointData()

        wayPoint.name = "BSR Basra International Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 30.548889, longitude: 47.662472)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "AMS Amsterdam Schipol Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 52.308056, longitude: 4.764167)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "KAZ Plant"
        wayPoint.location = CLLocationCoordinate2D (latitude: 30.269108, longitude: 47.7307172)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Edwalton"
        wayPoint.location = CLLocationCoordinate2D (latitude: 52.9125, longitude: -1.1125)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Charlestown Circle"
        wayPoint.location = CLLocationCoordinate2D (latitude: 57.0959676, longitude: -2.0971963)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "ABZ Aberdeen International Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 57.2037, longitude: -2.198055)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "LHR London Heathrow Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 51.4775, longitude: -0.461389)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Aberdeen City"
        wayPoint.location = CLLocationCoordinate2D (latitude: 57.15, longitude: -2.11)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "DXB Dubai International Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 25.252778, longitude: 55.364444)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "CDG Charles de Gaulle Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 49.009722, longitude: 2.547778)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "DOH Doha Hamad International Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 25.273056, longitude: 51.608056)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "LAX Los Angeles International Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 33.9425, longitude:-118.408056)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "AMM Amman Queen Alia International Airport"
        wayPoint.location = CLLocationCoordinate2D (latitude: 31.7225, longitude: 35.993333)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Cove Bay"
        wayPoint.location = CLLocationCoordinate2D (latitude: 57.105, longitude: -2.089)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Jodrell Bank Observatory"
        wayPoint.location = CLLocationCoordinate2D (latitude: 53.23625, longitude: -2.307139)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Glasgow"
        wayPoint.location = CLLocationCoordinate2D (latitude: 55.860916, longitude: -4.251433)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Nottingham"
        wayPoint.location = CLLocationCoordinate2D (latitude: 52.95, longitude: -1.15)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Premier Inn Glasgow"
        wayPoint.location = CLLocationCoordinate2D (latitude: 55.85779, longitude: -4.2912021)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Ian's Flat"
        wayPoint.location = CLLocationCoordinate2D (latitude: 55.8633114, longitude: -4.2916313)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Apple Park"
        wayPoint.location = CLLocationCoordinate2D (latitude: 37.334722, longitude: -122.008889)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        print (wayPointManager.getWayPointCount())
        
        determineMyCurrentLocation()
        
        refreshSortAndFilterData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wayPointManager.getWayPointCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WayPointListCell")!
        
        cell.textLabel?.text = wayPointManager.getWayPoint(item: indexPath.row).name
        
        let distanceInMeters = Measurement(value: wayPointManager.wayPointDistance(item: indexPath.row, from: currentLocation), unit: UnitLength.meters)
        let distanceFormatter = MeasurementFormatter()
        distanceFormatter.unitStyle = .medium
        distanceFormatter.numberFormatter.maximumFractionDigits = 1
        distanceFormatter.numberFormatter.minimumFractionDigits = 1
        let distanceString = distanceFormatter.string(from: distanceInMeters)
        
        let bearing = wayPointManager.wayPointBearing(item: indexPath.row, from: currentLocation)
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
            // locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        print ("heading: \(newHeading)")
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
                print (firstLocation!.subLocality, firstLocation!.locality, firstLocation!.country)

                OperationQueue.main.addOperation {
                    self.currentLocationLabel.text = firstLocation!.subLocality! + ", " + firstLocation!.locality! + ", " + firstLocation!.country!
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
        
        currentLatLongLabel.text = latString! + ", " + longString!
        
        tableView.reloadData()
    }
}

