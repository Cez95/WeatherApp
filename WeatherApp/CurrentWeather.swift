//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Chris Olson on 7/11/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
/////////////////////////////////////////////////////////////////////////////////////
    // Data encapsulation. This is how to always use data encapsulation to protect your data. In this case, we are protecting the data we recieve from our api call. Data encapsulation is best practice and prevents just anybody from disrupting your variables. This is nesacary for safe data!!!!
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        // This part of our date variable is how we format the style of the date. EX: YY-mm-dd. This allows us to get date and fromat it the way we want, then save it as our date. This is important for futrue use
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
//////////////////////////////////////////////////////////////////////////////////////
    
// This function and code block will show you how to pull from an API and store that data to a class we created called CurrentWeather
    
    func downloadWeatherDetails (completed: @escaping DownloadComplete) {
        // Let Alamofire know where to download from
        // This tells Alamofire where we want to pull data from and the .responseJSON tells the format we want it in
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result // Every request has a response, and every response has a result. This will be go to format with pulling from APIs
            
            // This allows us to go into the JSON file which is made like a dictionary
            if let dict = result.value as? Dictionary<String, Any> { // First level of the JSON dictonary
                
                // This tells our function to look through the dictionary for a key called "name"
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                // The weather is inside of a dictionary which is inside an arry. This is how we get into the array
                if let weather = dict["weather"]as? [Dictionary<String, Any>] {
                    // Now that were in the array, the first index of it is the dictionary that weather is in. So we indicate the [0] to get into the dictionary
                    if let main = weather[0]["main"] as? String {  // They dictioanry key is called "main:"
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                
                // This moves us into the key "main" Which holds a dictionary
                if let main = dict["main"] as? Dictionary<String, Any> {
                    // In the "main" keys dictionary we move select the "temp" key
                    if let currentTemperature = main["temp"] as? Double {
                        // Because the value of main["temp"] is a double thats in kevlins, we do this to convert to farenheight
                        let kelvinToFarenheightPreDivision = (currentTemperature * (9/5) - 459.67)
                        let kelvinToFarenheight = Double(round(10 * kelvinToFarenheightPreDivision/10))
                        self._currentTemp = kelvinToFarenheight
                        print(self._currentTemp)
                        }
                    }
                
            }
            completed() // This lets our function know when we are finished using the API
        }
    }
///////////////////////////////////////////////////////////////////////////////////
}

