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
    
    
    func getWayPoint (item: Int) -> WayPointData {
        return wayPoints[item]
    }
}
