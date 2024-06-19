//
//  PlanModel.swift
//  WeatherPlan
//
//  Created by Yunki on 6/16/24.
//

import Foundation

struct PlanModel: Identifiable {
    var id: UUID = .init()
    var isDone: Bool = false
    var date: Date = .init()
    var title: String = ""
}

