//
//  WeatherManager.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

// MARK: - Gureum
import WeatherKit
import CoreLocation.CLLocation

class WeatherManager: WeatherInterface {
    var weatherService: WeatherService = .shared
    
    /// fetchWeather(location: CLLocation) -> [WeatherModel]
    /// - Parameter location: 특정 장소의 위치 정보
    /// - Returns: 열흘간의 날짜(Date)별 날씨(WeatherInfomation) 배열
    @MainActor
    func fetchWeather(location: CLLocation) async -> [WeatherModel] {
        var result: [WeatherModel] = []
        
        guard let weatherData = try? await weatherService.weather(for: location, including: .daily) else { return [] }
        let dayWeathers = weatherData.forecast
        
        for dayWeather in dayWeathers {
            let newWeatherModel = WeatherModel(
                date: dayWeather.date.beginOfDate,
                symbolName: dayWeather.symbolName,
                weatherInfomation: .sunny,
                lowTemperature: Int(round(dayWeather.lowTemperature.value)),
                highTemperature: Int(round(dayWeather.highTemperature.value))
            )
            result.append(newWeatherModel)
        }
        return result
    }
}
