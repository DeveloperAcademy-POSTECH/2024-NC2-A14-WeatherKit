//
//  WeatherModel.swift
//  WeatherPlan
//
//  Created by Yunki on 6/16/24.
//

import Foundation

struct WeatherModel: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let weatherCondition: WeatherCondition
    
    enum WeatherCondition {
        case rainy
        case heat
        case dusty
        case ultraviolet
        case windy
        case sunny
    }
}
