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
        var model: [Date: WeatherModel] = [:]
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
            guard let self = self else { return }
            Task {
                let weatherData = await self.weatherService.fetchWeather(location: location)
                self._state.model.removeAll(keepingCapacity: true)
                for data in weatherData {
                    self._state.model[data.date] = data
                }
            }
        }
        
        fetchWeatherData()
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
