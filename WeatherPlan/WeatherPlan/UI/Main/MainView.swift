//
//  MainView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/17/24.
//

import SwiftUI

struct MainView: View {
    /// Calendar
//    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    
    @State private var calendarSize: CGSize = .init(width: CGFloat.infinity, height: CGFloat.infinity)
    
    @ScaledMetric private var weatherHeight: CGFloat = 36
    @ScaledMetric private var weatherWidth: CGFloat = 38
    
    /// Plan
//    @State private var planData: [PlanModel] = PlanModel.mock
    // for Sheet
    @State private var planModel: PlanModel?
    
    
    /// UseCase
    @State private var weatherUseCase: WeatherUseCase = .init(locationService: LocationManager(), weatherService: WeatherManager())
    @State private var planUseCase: PlanUseCase = .init(dataService: DataService.shared)
    
    var body: some View {
        
        VStack(spacing: 48) {
            // MARK: - Calendar
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
            
            // MARK: - WeatherDetail
            HStack {
                VStack(alignment: .leading) {
                    if let data = weatherUseCase.state.model[planUseCase.state.currentDate.beginOfDate] {
                        HStack {
                            Text("\(data.lowTemperature)º")
                            RoundedRectangle(cornerRadius: 21)
                                .frame(width: 50,height: 4)
                                .foregroundStyle(LinearGradient(colors: [Color(red: 113/255, green: 119/255, blue: 255/255), Color(red: 255/255, green: 123/255, blue: 123/255)], startPoint: .leading, endPoint: .trailing))
                            Text("\(data.highTemperature)º")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    }
                    
                    if let data = weatherUseCase.state.model[planUseCase.state.currentDate.beginOfDate] {
                        Text(data.weatherInfomation.description)
                            .font(.largeTitle)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                    } else {
                        Text("날씨 정보가 없는 날이예요")
                            .font(.largeTitle)
                            .bold()
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                    }
                }
                Spacer()
                if let data = weatherUseCase.state.model[planUseCase.state.currentDate.beginOfDate] {
                    Image(systemName: data.weatherInfomation.symbolName)
                        .font(.system(size: 90))
                        .frame(width: 120, height: 120)
                        .foregroundStyle(data.weatherInfomation.symbolColor)
                } else {
                    Image(systemName: "exclamationmark.magnifyingglass")
                        .font(.system(size: 90))
                        .frame(width: 120, height: 120)
                        .foregroundStyle(Color(uiColor: .systemGray4))
                }
            }
            .padding(.horizontal, 18)
            
            
            
            // MARK: - Planner
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
    //    MainView()
    ContentView()
}
