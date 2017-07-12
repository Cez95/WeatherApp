//
//  ViewController.swift
//  WeatherApp
//
//  Created by Chris Olson on 7/10/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentWeatherCondition: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather : CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // WhenInUseAuthorization only tracks location when the app is in use. Its best to keep this option for when the app is not running unless it is for something like GPS
        locationManager.stopMonitoringSignificantLocationChanges() // Keeps track of significant gps changes
        
        
        // Essential for implementing our tableview delegate and tableview datasource.
        // Do this every time you are working with table views
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()

        

       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus () {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // If we are authorized to get this location we then save it into the variable currentLocation
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude // This will store the latitude associated to the current location to our static variable latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            // This will setup UI to load downloaded data
            currentWeather.downloadWeatherDetails{
                self.downloadForecast{
                    self.updateMainUI()
                }
            }
       
        } else { // This else is for the first time a user uses the app and it prompts them to use your current location
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus() // Need to call the function again so that we can save the current location.
        }
    }
    
    // This will download our forecast weather data for our tableview (This is like the currentweather downloadWeatherDetails func)
    func downloadForecast(completed: @escaping DownloadComplete) {
        Alamofire.request(CURRENT_FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                
                if let list = dict["list"] as? [Dictionary<String, Any>] { // This gets us inside the first key (list) of the first dictionary
                    // This allows us for every dictionary inside of the array, to  create a new dictionary we can pull data from. IE for every new forecast we have a new dictionary
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.tableView.reloadData()

                }
                completed() // Tells the function we are finished pulling data from the API
            }
            
        }
    }
    
    
////////////////////////////////////////////////////////////////////////////////
    //Essential Tableview functions. VERY IMPORTANT
    
    // First function. Tells the tableview how many sections it needs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Second function: This tells our tableview how many rows we need. A row is cell ie. prototype cells in the app.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count // gives us the amount of rows as elements in our forecasts array
    }
    
    // Third function: This tells our tableview that it needs to recreate the first cell like we have designed in the app. This is our format recreator
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // This is where we identify which cell we want to resue. We do this by giving our prototype cell an identifier in the attribute inspector (weather)
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weather", for: indexPath) as? WeatherCell {//for: indexPath always
        
            let forecast = forecasts[indexPath.row] // Each cell created gets an index.
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    
    }
/////////////////////////////////////////////////////////////////////////////////
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date // Gets the currentweather date and sets it as the datelabel
        currentWeatherCondition.text = currentWeather.weatherType // Gets the current weather condition and puts it in as current weather condition label
        locationLabel.text = currentWeather.cityName // Gets the city from where we are searching the weather and puts it in as location label
        degreeLabel.text = "\(currentWeather.currentTemp)" // Gets the current weather temp and puts it in as the degreelabel
        
        weatherImage.image = UIImage(named: currentWeather.weatherType) // This lodas the images because they are named the same as the weather type
        
    }
    


}

