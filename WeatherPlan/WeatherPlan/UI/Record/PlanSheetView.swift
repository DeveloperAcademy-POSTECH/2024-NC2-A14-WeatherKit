//
//  PlanSheetView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/19/24.
//

import SwiftUI

struct PlanSheetView: View {
    @State var title: String
    @State var date: Date
    
    var body: some View {
        Form {
            TextField("일정 제목", text: $title)
            DatePicker("날짜", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .padding(.vertical, -1)
        }
    }
}

#Preview {
    PlanSheetView(title: "", date: .now)
}
