//
//  MainView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/17/24.
//

import SwiftUI

struct MainView: View {
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    
    @State private var planData: [PlanModel] = PlanModel.mock
    
    @State private var calendarSize: CGSize = .init(width: CGFloat.infinity, height: CGFloat.infinity)
    
    var body: some View {
        
        VStack {
            // MARK: - Calendar
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    HStack(spacing: 14) {
                        ForEach(week, id: \.id) { day in
                            VStack {
                                Text(day.date.format("E"))
                                    .font(.footnote)
                                
                                VStack(spacing: 4) {
                                    Image(systemName: "cloud.heavyrain")
                                        .font(.title2)
                                    
                                    Text(day.date.format("d"))
                                        .font(.footnote)
                                        .bold()
                                    
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundStyle(.gray)
                                }
                                .frame(minWidth: 40)
                                .padding(.vertical, 8)
                                .background {
                                    RoundedRectangle(cornerRadius: 36)
                                        .foregroundStyle(Color(uiColor: .systemGray6))
                                }
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
                                    if value.rounded() == 16 && createWeek {
                                        if weekSlider.indices.contains(currentWeekIndex) {
                                            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                                                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                                                weekSlider.removeLast()
                                                currentWeekIndex = 1
                                                currentDate.moveToPreviousWeek()
                                            }
                                            
                                            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == weekSlider.count - 1 {
                                                weekSlider.append(lastDate.createNextWeek())
                                                weekSlider.removeFirst()
                                                currentWeekIndex = weekSlider.count - 2
                                                currentDate.moveToNextWeek()
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
                    HStack {
                        Text("18º")
                        RoundedRectangle(cornerRadius: 21)
                            .frame(width: 50,height: 4)
                            .foregroundStyle(LinearGradient(colors: [Color(red: 113/255, green: 119/255, blue: 255/255), Color(red: 255/255, green: 123/255, blue: 123/255)], startPoint: .leading, endPoint: .trailing))
                        Text("31º")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    
                    Text("일교차가 많이 클 것 같아요")
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(2, reservesSpace: true)
                }
                Spacer()
                Image(systemName: "thermometer.low")
                    .font(.system(size: 90))
                    .frame(width: 120, height: 120)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 40)
            
            Divider()
                .padding()
            
            // MARK: - Planner
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(planData, id: \.id) { plan in
                        HStack {
                            ZStack {
                                Image(systemName: plan.isDone ? "checkmark.circle.fill" : "circle")
                                
                                RoundedRectangle(cornerRadius: 21)
                                    .frame(width: 2, height: 40)
                                    .offset(y: 40)
                                    .opacity(plan.id != planData.last!.id ? 1 : 0)
                            }
                            
                            Text(plan.date.format("a hh:mm"))
                            
                            Text(plan.title)
                            
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(currentDate.format("y년 M월"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                .tint(.primary)
            }
        }
        
    }
}

#Preview {
    //    MainView()
    ContentView()
}
