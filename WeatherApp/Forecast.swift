//
//  Forecast.swift
//  WeatherApp
//
//  Created by Chris Olson on 7/11/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String{
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var higTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    // Weather temps are inside a dictionary thats inside another dictionary, thats inside an arry. This is the final level in which we can access data we need
    init(weatherDict: Dictionary<String, Any>) { // When we say Dictionary<String, Any> We are saying this is a dictionary with strink keys and any objects for values.
        if let temp = weatherDict["main"] as? Dictionary<String, Any> {
            if let min = temp["temp_min"] as? Double{
                // Because the value of main["temp"] is a double thats in kevlins, we do this to convert to farenheight
                let kelvinToFarenheightPreDivision = (min * (9/5) - 459.67)
                let kelvinToFarenheight = Double(round(10 * kelvinToFarenheightPreDivision/10))
                self._lowTemp = "\(kelvinToFarenheight)"
                
            }
            
            // Same thing as mind but for max
            if let max = temp["temp_max"] as? Double {
                let kelvinToFarenheightPreDivision = (max * (9/5) - 459.67)
                let kelvinToFarenheight = Double(round(10 * kelvinToFarenheightPreDivision/10))
                self._highTemp = "\(kelvinToFarenheight)"
            }
        }
        
        // While looping through each list in the API we now go into the array called weather
        if let weather = weatherDict["weather"] as? [Dictionary<String, Any>] { //Indicates that weather is an array with dictionaries inside
            if let main = weather[0]["main"] as? String {
                self._weatherType = main.capitalized
            }
            
        }
        
        // This will access the dt key inside the list dictionary and will convert the date from UTC time. Then using the extension we made outside the class, It will return us the day of the week.
        if let date = weatherDict["dt_txt"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // This is the format we the api gives us in JSON
            let dateString = dateFormatter.date(from: date) // This converts the JSON format to a newly formated one
            dateFormatter.dateFormat = "EEEE ha" // This displays the day of the week and the hour of the day
            self._date = dateFormatter.string(from: dateString!)
            }
        }
  
}

// This extension allows us to get the day of the week from the date we pull out each time we loop. Extensions are always made outside of classes.
extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
