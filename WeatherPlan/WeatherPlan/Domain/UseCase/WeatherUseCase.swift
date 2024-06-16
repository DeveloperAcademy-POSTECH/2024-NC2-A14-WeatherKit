//
//  WeatherUseCase.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

import SwiftUI

@Observable
class WeatherUseCase {
    private var locationService: LocationInterface
    private let weatherService: WeatherInterface
    
    struct State {
        var model: [Date: WeatherModel.WeatherCondition] = [:]
    }
    
    private var _state: State = .init()
    var state: State {
        _state
    }
    
    private func fetchWeatherData() {
        locationService.triggerHandler()
    }
    
    init(locationService: LocationInterface, weatherService: WeatherInterface) {
        self.locationService = locationService
        self.weatherService = weatherService
        
        self.locationService.locationUpdateHandler = { [weak self] location in
            guard let weatherData = self?.weatherService.fetchWeather(location: location) else { return }
            self?._state.model.removeAll(keepingCapacity: true)
            for data in weatherData {
                self?._state.model[data.date] = data.weatherCondition
            }
        }
    }
}

extension WeatherUseCase {
    enum Action {
        case fetchWeatherData
    }
    
    func execute(action: Action) {
        switch action {
        case .fetchWeatherData:
            fetchWeatherData()
        }
    }
}
