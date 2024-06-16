//
//  WeatherUseCase.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

import SwiftUI
import WeatherKit
import CoreLocation.CLLocation

@Observable
class WeatherUseCase {
    private let locationService: LocationInterface
    private let weatherService: WeatherInterface
    
    struct State {
        
    }
    
    init(locationService: LocationInterface, weatherService: WeatherInterface) {
        self.locationService = locationService
        self.weatherService = weatherService
    }
}

extension WeatherUseCase {
    enum Action {
        case fetchWeatherData(CLLocation)
    }
    
    func execute(action: Action) {
        switch action {
        case let .fetchWeatherData(location):
            break
        }
    }
}
