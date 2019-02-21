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


private enum sortTypes {
    case    alphabetical
    case    distance
}




class WayPointManager {
    
    static let sharedInstance = WayPointManager()
    
    private var wayPoints = [WayPointData]()
    private var currentSortType: sortTypes = .alphabetical
    
    
    init() {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
    }
    
    
    func getWayPointCount () -> Int {
        return wayPoints.count
    }
    
    
    func sortWayPoints () {
        switch currentSortType {
        case .alphabetical:
            wayPoints = wayPoints.sorted(by: { $0.name < $1.name})
        case .distance: // reverse alpha for now!
            wayPoints = wayPoints.sorted(by: { $0.name > $1.name})
        }
    }
    
    
    func addWayPoint (wayPoint: WayPointData) {
        let matchingWayPoints = wayPoints.filter { $0.name == wayPoint.name }
        
        if (matchingWayPoints.count == 0) {
            // print ("adding wayPoint \(wayPoint.name)")
            wayPoints.append (wayPoint)
            sortWayPoints()
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
        
        let degrees = radiansToDegrees(radians: radiansBearing)
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
    
    
    
    
    func createInitialWayPoints () {
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
        
        wayPoint.name = "Royal Observatory, Greenwich "
        wayPoint.location = CLLocationCoordinate2D (latitude: 51.4778, longitude: -0.0014)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Zero zero"
        wayPoint.location = CLLocationCoordinate2D (latitude: 0, longitude: 0)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "McMurdo Station"
        wayPoint.location = CLLocationCoordinate2D (latitude: -77.846323, longitude: 166.668235)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
        
        wayPoint.name = "Apple Park"
        wayPoint.location = CLLocationCoordinate2D (latitude: 37.334722, longitude: -122.008889)
        wayPointManager.addWayPoint(wayPoint: wayPoint)
    }
}
