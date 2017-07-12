//
//  Location.swift
//  WeatherApp
//
//  Created by Chris Olson on 7/11/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    // static var is a variable accessible throuout the app
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
    
    

}
