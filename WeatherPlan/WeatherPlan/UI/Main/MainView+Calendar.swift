//
//  MainView+Calendar.swift
//  WeatherPlan
//
//  Created by Yunki on 6/20/24.
//

import SwiftUI

extension MainView {
    struct CalendarView: View {
        @Binding var weatherUseCase: WeatherUseCase
        @Binding var planUseCase: PlanUseCase
        
        @State private var weekSlider: [[Date.WeekDay]] = []
        @State private var currentWeekIndex: Int = 1
        @State private var createWeek: Bool = false
        
        @State private var calendarSize: CGSize = .init(width: CGFloat.infinity, height: CGFloat.infinity)
        
        @ScaledMetric private var weatherHeight: CGFloat = 36
        @ScaledMetric private var weatherWidth: CGFloat = 38
        
        var body: some View {
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    HStack(spacing: 14) {
                        ForEach(week, id: \.id) { day in
                            VStack {
                                Text(day.date.format("E"))
                                    .font(.footnote)
                                    .foregroundStyle(
                                        day.date.weekday == 1
                                        ? .red
                                        : day.date.weekday == 7
                                        ? .blue
                                        : .primary
                                    )
                                
                                VStack(spacing: 4) {
                                    if let weatherData = weatherUseCase.state.model[day.date.beginOfDate] {
                                        Image(systemName: weatherData.symbolName)
                                            .font(.title2)
                                            .frame(width: weatherWidth, height: weatherHeight, alignment: .top)
                                    } else {
                                        Text("-")
                                            .font(.title2)
                                            .frame(width: weatherWidth, height: weatherHeight, alignment: .top)
                                    }
                                    
                                    Text(day.date.format("d"))
                                        .font(.footnote)
                                        .bold()
                                    
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundStyle(.gray)
                                        .opacity(planUseCase.isPlanExist(at: day.date) ? 1 : 0)
                                }
                                .frame(minWidth: 40)
                                .padding(.vertical, 8)
                                .background {
                                    if planUseCase.state.currentDate.isSameDate(with: day.date) {
                                        RoundedRectangle(cornerRadius: 36)
                                            .foregroundStyle(Color(uiColor: .systemGray6))
                                    }
                                }
                                .overlay {
                                    if Date().isSameDate(with: day.date) {
                                        RoundedRectangle(cornerRadius: 36)
                                            .stroke(Color(uiColor: .systemGray6))
                                    }
                                }
                            }
                            .onTapGesture {
                                planUseCase.execute(action: .changeDate(day.date))
                                planUseCase.execute(action: .readPlan)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .onGeometrySizeChange { calendarSize = $0 }
                    .background {
                        GeometryReader { geometry in
                            let minX = geometry.frame(in: .global).minX
                            
                            Color.clear
                                .preference(key: OffsetKey.self, value: minX)
                                .onPreferenceChange(OffsetKey.self) { value in
                                    if value.rounded() == 15 && createWeek {
                                        if weekSlider.indices.contains(currentWeekIndex) {
                                            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                                                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                                                weekSlider.removeLast()
                                                currentWeekIndex = 1
                                            }
                                            
                                            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == weekSlider.count - 1 {
                                                weekSlider.append(lastDate.createNextWeek())
                                                weekSlider.removeFirst()
                                                currentWeekIndex = weekSlider.count - 2
                                            }
                                        }
                                        createWeek = false
                                    }
                                }
                        }
                    }
                    .tag(index)
                }
                .padding(.horizontal, 18)
            }
            .frame(maxHeight: calendarSize.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onAppear {
                weekSlider.append(Date().createPreviousWeek())
                weekSlider.append(Date().fetchWeek())
                weekSlider.append(Date().createNextWeek())
            }
            .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
                if newValue == 0 || newValue == weekSlider.count - 1 {
                    createWeek = true
                }
            }
        }
    }
}
