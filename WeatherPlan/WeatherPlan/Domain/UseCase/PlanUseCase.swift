//
//  PlanUseCase.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

import SwiftUI

@Observable
class PlanUseCase {
    private var dataService: DataServiceInterface
    
    struct State {
        var currentDate: Date = .init()
        var model: [PlanModel] = []
    }
    
    private var _state: State = .init()
    var state: State { _state }
    
    init(dataService: DataServiceInterface) {
        self.dataService = dataService
    }
}

extension PlanUseCase {
    enum Action {
        case changeDate(Date)
        case togglePlan(PlanModel)
        case createPlan(PlanModel)
        case readPlan
        case updatePlan(UUID, PlanModel)
        case deletePlan(UUID, Date)
    }
    
    func execute(action: Action) {
        switch action {
        case let .changeDate(date):
            _state.currentDate = date
        case let .togglePlan(plan):
            var plan = plan
            plan.isDone.toggle()
            dataService.updatePlan(id: plan.id, data: plan)
            _state.model = dataService.readPlan(date: _state.currentDate.beginOfDate)
        case let .createPlan(plan):
            dataService.createPlan(data: plan)
        case .readPlan:
            _state.model = dataService.readPlan(date: _state.currentDate.beginOfDate)
        case let .updatePlan(id, plan):
            dataService.updatePlan(id: id, data: plan)
        case let .deletePlan(id, date):
            dataService.deletePlan(id: id, date: date)
        }
    }
    
    func isPlanExist(at date: Date) -> Bool {
        return dataService.isPlanExist(at: date)
    }
}
