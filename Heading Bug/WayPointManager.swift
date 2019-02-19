//
//  WayPointManager.swift
//  Heading Bug
//
//  Created by Steve on 19/02/2019.
//  Copyright © 2019 Steve. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

var wayPointManager = WayPointManager()




struct WayPointData {
    var name: String = ""
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: 0, longitude: 0)
}



private struct WayPointContainer {
    var wayPoints: [WayPointData]
}



class WayPointManager {
    
    static let sharedInstance = WayPointManager()
    
    private var wayPoints = [WayPointData]()
    
    init() {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
    }
    
    
    func getWayPointCount () -> Int {
        return wayPoints.count
    }
    
    
    func addWayPoint (wayPoint: WayPointData) {
        let matchingWayPoints = wayPoints.filter { $0.name == wayPoint.name }
        
        if (matchingWayPoints.count == 0) {
            print ("adding wayPoint \(wayPoint.name)")
            wayPoints.append (wayPoint)
        } else {
            print ("duplicate wayPoint \(wayPoint.name)")
        }
    }
    
    
    func wayPointDistance (item: Int, from: CLLocationCoordinate2D) -> CLLocationDistance {
        let itemWayPoint = getWayPoint (item: item)
        
        let locationOne = CLLocation (latitude: itemWayPoint.location.latitude, longitude: itemWayPoint.location.longitude)
        let locationTwo = CLLocation (latitude: from.latitude, longitude: from.longitude)
        
        return (locationOne.distance(from: locationTwo))
    }
    
    
    func wayPointBearing (item: Int, from: CLLocationCoordinate2D) -> Double {
        let itemWayPoint = getWayPoint (item: item)

        let locationFrom = CLLocation (latitude: itemWayPoint.location.latitude, longitude: itemWayPoint.location.longitude)
        let itemLocation = CLLocation (latitude: from.latitude, longitude: from.longitude)
        
        let bearing = getBearingBetweenTwoPoints1(point1: itemLocation, point2: locationFrom)
        
        return (bearing)
    }
    
    
    func getWayPoint (item: Int) -> WayPointData {
        return wayPoints[item]
    }
    
    
    private func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    private func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    private func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
}




