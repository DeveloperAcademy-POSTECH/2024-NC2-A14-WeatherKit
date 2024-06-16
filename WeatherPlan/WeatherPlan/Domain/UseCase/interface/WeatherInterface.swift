//
//  WeatherInterface.swift
//  WeatherPlan
//
//  Created by Yunki on 6/16/24.
//

import WeatherKit
import CoreLocation.CLLocation

protocol WeatherInterface {
    func fetchWeather(location: CLLocation) -> [DayWeather]
}
