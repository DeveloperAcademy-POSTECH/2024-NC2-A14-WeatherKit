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
    
    /// fetchWeather(location: CLLocation) -> [WeatherModel]
    /// - Parameter location: 특정 장소의 위치 정보
    /// - Returns: 열흘간의 날짜(Date)별 날씨(WeatherCondition) 배열
    func fetchWeather(location: CLLocation) -> [WeatherModel] {
        // TODO: - 이 메서드 완성
        return []
    }
}
