//
//  Date+Extensions.swift
//  WeatherPlan
//
//  Created by Yunki on 6/16/24.
//

import Foundation

extension Date {
    /// Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = .autoupdatingCurrent
        formatter.timeZone = .current
        
        return formatter.string(from: self)
    }
    
    /// Checking Two Dates are same
    func isSameDate(with date: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = .autoupdatingCurrent
        calendar.locale = .autoupdatingCurrent
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    var beginOfDate: Self {
        var calendar = Calendar.current
        calendar.timeZone = .autoupdatingCurrent
        calendar.locale = .autoupdatingCurrent
        return calendar.startOfDay(for: self)
    }
    
    var weekday: Int {
        var calendar = Calendar.current
        calendar.timeZone = .autoupdatingCurrent
        calendar.locale = .autoupdatingCurrent
        return calendar.component(.weekday, from: self)
    }
}

extension Date {
    mutating func moveToNextWeek() {
        self = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: self) ?? self
    }
    
    mutating func moveToPreviousWeek() {
        self = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: self) ?? self
    }
}

extension Date {
    /// Fetching Week Based on given Date
    func fetchWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: self)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else { return [] }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        return week
    }
    
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        guard let nextWeek = calendar.date(byAdding: .weekOfMonth, value: 1, to: self) else { return [] }
        return nextWeek.fetchWeek()
    }
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        guard let previousWeek = calendar.date(byAdding: .weekOfMonth, value: -1, to: self) else { return [] }
        return previousWeek.fetchWeek()
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}
