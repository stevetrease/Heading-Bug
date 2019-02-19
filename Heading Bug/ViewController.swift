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

        wayPoint.name = "BSR"
        wayPoint.location = CLLocationCoordinate2D (latitude: 30.548889, longitude: 47.662472)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "ABZ"
        wayPoint.location = CLLocationCoordinate2D (latitude: 57.2037, longitude: -2.198055)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "LHR"
        wayPoint.location = CLLocationCoordinate2D (latitude: 51.4775, longitude: -0.461389)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Aberdeen City"
        wayPoint.location = CLLocationCoordinate2D (latitude: 57.15, longitude: -2.11)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "DXB"
        wayPoint.location = CLLocationCoordinate2D (latitude: 25.252778, longitude: 55.364444)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "CDG"
        wayPoint.location = CLLocationCoordinate2D (latitude: 49.009722, longitude: 2.547778)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "DOH"
        wayPoint.location = CLLocationCoordinate2D (latitude: 25.273056, longitude: 51.608056)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "LAX"
        wayPoint.location = CLLocationCoordinate2D (latitude: 33.9425, longitude:-118.408056)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "AMM"
        wayPoint.location = CLLocationCoordinate2D (latitude: 31.7225, longitude: 35.993333)
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            // locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        currentLocation = CLLocationCoordinate2D (latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    
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

