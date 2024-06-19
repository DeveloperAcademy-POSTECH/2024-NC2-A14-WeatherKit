//
//  DataServiceInterface.swift
//  WeatherPlan
//
//  Created by Yunki on 6/19/24.
//

import Foundation

protocol DataServiceInterface {
    func createPlan(data: PlanModel)
    func readPlan(date: Date) -> [PlanModel]
    func updatePlan(id: UUID, data: PlanModel)
    func deletePlan(id: UUID, date: Date)
    func isPlanExist(at date: Date) -> Bool
}
