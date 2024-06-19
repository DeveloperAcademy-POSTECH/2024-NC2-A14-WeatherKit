//
//  WeatherModel.swift
//  WeatherPlan
//
//  Created by Yunki on 6/16/24.
//

import SwiftUI

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
        
        var description: String {
            switch self {
            case .rainy: return "비 예보가 있으니 우산을 챙기세요"
            case .cold: return "기온이 많이 낮은 날이에요"
            case .heat: return "기온이 많이 높은 날이에요"
            case .diurnalRange: return "일교차가 많이 클 것 같아요"
            case .windy: return "바람이 쌩쌩 부는 날이에요"
            case .sunny: return "햇빛이 아주 강렬한 날이에요"
            case .good: return "놀러 가기에 최적의 날씨예요"
            }
        }
        
        var symbolName: String {
            switch self {
            case .rainy: return "cloud.heavyrain"
            case .cold: return "thermometer.snowflake"
            case .heat: return "thermometer.sun"
            case .diurnalRange: return "thermometer.low"
            case .windy: return "wind"
            case .sunny: return "sun.max.trianglebadge.exclamationmark"
            case .good: return "sun.max"
            }
        }
        
        var symbolColor: Color {
            switch self {
            case .rainy: return .primaryBlue
            case .cold: return .primaryRed
            case .heat: return .primaryRed
            case .diurnalRange: return .primaryRed
            case .windy: return .primaryGreen
            case .sunny: return .primaryYellow
            case .good: return .primaryBlue
            }
        }
    }
}
