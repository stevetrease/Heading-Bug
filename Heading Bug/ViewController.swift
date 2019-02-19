//
//  ViewController.swift
//  Heading Bug
//
//  Created by Steve on 19/02/2019.
//  Copyright © 2019 Steve. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var currentLatLongLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    let currentLocation = CLLocationCoordinate2D (latitude: 57.105, longitude: -2.089)
    

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
        
        
        print (wayPointManager.getWayPointCount())
        
        refreshSortAndFilterData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        return wayPointManager.getWayPointCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
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
    
    @objc func refreshSortAndFilterData () {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        currentLatLongLabel.text = String (currentLocation.latitude) + ", " + String (currentLocation.longitude)
        
        tableView.reloadData()
    }
}

