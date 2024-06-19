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
            let date = dayWeather.date.beginOfDate
            let symbolNama = dayWeather.symbolName
            let weatherInfomation: WeatherModel.WeatherInfomation = importantWeatherInfomation(dayWeather)
            let lowTemperature = Int(round(dayWeather.lowTemperature.value))
            let highTemperature = Int(round(dayWeather.highTemperature.value))
            
            let newWeatherModel = WeatherModel(
                date: date,
                symbolName: dayWeather.symbolName,
                weatherInfomation: weatherInfomation,
                lowTemperature: lowTemperature,
                highTemperature: highTemperature
            )
            result.append(newWeatherModel)
        }
        return result
    }
    
    private func importantWeatherInfomation(_ weather: DayWeather) -> WeatherModel.WeatherInfomation {
        if weather.precipitationChance >= 0.5 { return .rainy }
        if weather.lowTemperature.value <= -4 { return .cold }
        if weather.highTemperature.value >= 30 { return .heat }
        if weather.highTemperature.value - weather.lowTemperature.value >= 12 { return .diurnalRange }
        if weather.uvIndex.value >= 6 { return .sunny }
        if weather.wind.speed.value >= 8 { return .windy}
        return .good
    }
}
