//
//  MainView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/17/24.
//

import SwiftUI

struct MainView: View {
    /// UseCase
    @State private var weatherUseCase: WeatherUseCase = .init(locationService: LocationManager(), weatherService: WeatherManager())
    @State private var planUseCase: PlanUseCase = .init(dataService: DataService.shared)
    
    // for Sheet
    @State private var planModel: PlanModel?
    
    var body: some View {
        VStack(spacing: 48) {
            // MARK: - Calendar
            CalendarView(weatherUseCase: $weatherUseCase, planUseCase: $planUseCase)
            
            // MARK: - WeatherDetail
            WeatherDetailView(weatherUseCase: $weatherUseCase, planUseCase: $planUseCase)
            
            // MARK: - PlanList
            PlanListView(weatherUseCase: $weatherUseCase, planUseCase: $planUseCase, planModel: $planModel)
        }
        .onChange(of: planUseCase.state.currentDate, initial: true, { oldValue, newValue in
            planUseCase.execute(action: .readPlan)
        })
        .navigationTitle(planUseCase.state.currentDate.format("y년 M월")) // TODO: - 달력 이동하면 변하게 바꿔야함
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    planModel = .init(date: planUseCase.state.currentDate)
                } label: {
                    Image(systemName: "plus")
                }
                .tint(.primary)
            }
        }
        .sheet(item: $planModel) {
            planModel = nil
        } content: { plan in
            PlanSheetView(plan: plan, editType: (planModel?.title ?? "") == "" ? .create : .update, planUseCase: $planUseCase)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ContentView()
}
