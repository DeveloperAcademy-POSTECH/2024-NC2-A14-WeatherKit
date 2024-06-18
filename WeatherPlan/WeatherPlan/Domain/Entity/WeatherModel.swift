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
    let symbolName: String
    let weatherInfomation: WeatherInfomation
    let lowTemperature: Int
    let highTemperature: Int
    
    enum WeatherInfomation {
        case rainy // 비
        case cold // 추움
        case heat // 더움
        case diurnalRange // 일교차
        case windy // 강풍
        case sunny // 햇살강함
        case good // 날씨좋음
    }
}
