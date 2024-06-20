//
//  MainView+PlanListView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/20/24.
//

import SwiftUI

extension MainView {
    struct PlanListView: View {
        @Binding var weatherUseCase: WeatherUseCase
        @Binding var planUseCase: PlanUseCase
        
        @Binding var planModel: PlanModel?
        
        var body: some View {
            ScrollView {
                Divider()
                    .padding(.horizontal)
                
                if planUseCase.state.model.isEmpty {
                    Text("새로운 일정을 추가 해 보세요!")
                        .font(.body)
                        .foregroundStyle(.gray)
                        .padding(.vertical)
                } else {
                    VStack(alignment: .leading) {
                        ForEach(planUseCase.state.model, id: \.id) { plan in
                            HStack(alignment: .center) {
                                ZStack {
                                    Image(systemName: plan.isDone ? "checkmark.circle.fill" : "circle")
                                        .font(.body)
                                        .bold()
                                        .foregroundStyle(.secondary)
                                        .onTapGesture {
                                            planUseCase.execute(action: .togglePlan(plan))
                                        }
                                    
                                    if !planUseCase.state.model.isEmpty {
                                        RoundedRectangle(cornerRadius: 21)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 2, height: 40)
                                            .offset(y: 40)
                                            .opacity(plan.id != planUseCase.state.model.last!.id ? 1 : 0)
                                    }
                                }
                                
                                Text(plan.date.format("a hh:mm"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(plan.title)
                                    .font(.body)
                                    .bold()
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                            }
                            .padding(.vertical)
                            .onTapGesture {
                                planModel = plan
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
