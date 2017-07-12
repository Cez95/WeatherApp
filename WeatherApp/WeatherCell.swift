//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Chris Olson on 7/11/17.
//  Copyright © 2017 Chris Olson. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    // This assignes our api data to the labels displayed to the app
    func configureCell(forecast: Forecast){
        dayLabel.text = forecast.date
        weatherType.text = forecast.weatherType
        weatherIcon.image = UIImage(named: forecast.weatherType)
        highTempLabel.text = "\(forecast.higTemp)"
        lowTempLabel.text = "\(forecast.lowTemp)"
        
        
        
    }
    
   
  
}
