//
//  WeatherManager.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

// MARK: - Gureum
import WeatherKit
import CoreLocation.CLLocation

@Observable
class WeatherManager: WeatherInterface {
    var weatherService: WeatherService = .shared
    
    var weatherModels: [WeatherModel] = []
    
    /// fetchWeather(location: CLLocation) -> [WeatherModel]
    /// - Parameter location: 특정 장소의 위치 정보
    /// - Returns: 열흘간의 날짜(Date)별 날씨(WeatherCondition) 배열
    @MainActor
    func fetchWeather(location: CLLocation) -> [WeatherModel] {
//        var result: [WeatherModel] = []
        
        Task{
            let weatherData = try await weatherService.weather(for: location, including: .daily)
            let dayWeathers = weatherData.forecast
            
            for dayWeather in dayWeathers {
                let date = dayWeather.date
                let symbol = dayWeather.symbolName
                let newWeatherModel = WeatherModel(date: date, symbolName: symbol)
//                result.append(newWeatherModel)
                weatherModels.append(newWeatherModel)
            }
        }
//        return result
        return []
    }
}
