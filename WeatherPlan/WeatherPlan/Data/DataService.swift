//
//  DataService.swift
//  WeatherPlan
//
//  Created by Yunki on 6/19/24.
//

import Foundation

/// in memory Data Service
class DataService {
    static var shared: DataService = .init()
    
    private init() { }
    
    private var data: [Date: [PlanModel]] = [:]
}

extension DataService: DataServiceInterface {
    func createPlan(data: PlanModel) {
        self.data[data.date.beginOfDate, default: []].append(data)
    }
    
    func readPlan(date: Date) -> [PlanModel] {
        let dailyData = self.data[date.beginOfDate, default: []]
        return dailyData.sorted(by: { $0.date < $1.date })
    }
    
    func updatePlan(id: UUID, data: PlanModel) {
        guard let index = self.data[data.date.beginOfDate]?.firstIndex(where: { $0.id == id }) else { return }
        self.data[data.date.beginOfDate]![index] = data
    }
    
    func deletePlan(id: UUID, date: Date) {
        guard let index = self.data[date.beginOfDate]?.firstIndex(where: { $0.id == id }) else { return }
        self.data[date.beginOfDate]!.remove(at: index)
    }
    
    func isPlanExist(at date: Date) -> Bool {
        return !data[date, default: []].isEmpty
    }
}
