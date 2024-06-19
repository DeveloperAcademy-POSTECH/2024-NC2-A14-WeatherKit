//
//  PlanSheetView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/19/24.
//

import SwiftUI

struct PlanSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State var plan: PlanModel
    @State var editType: EditType
    
    @Binding var planUseCase: PlanUseCase // = .init(dataService: DataService.shared)
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    Section {
                        TextField("일정 제목", text: $plan.title)
                        DatePicker("날짜", selection: $plan.date, displayedComponents: [.date, .hourAndMinute])
                            .padding(.vertical, -1)
                    }
                    
                    if editType == .update {
                        Button(role: .destructive) {
                            planUseCase.execute(action: .deletePlan(plan.id, plan.date))
                            planUseCase.execute(action: .readPlan)
                        } label: {
                            HStack {
                                Spacer()
                                Text("일정 삭제")
                                Spacer()
                            }
                        }
                    }
                }
                
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: "apple.logo")
                    Text("Weather")
                    Text("|")
                    Link("데이터 소스", destination: URL(string: "https://developer.apple.com/weatherkit/data-source-attribution/")!)
                }
                .font(.caption)
                .foregroundStyle(Color(uiColor: .systemGray3))
            }
            .navigationTitle("일정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("취소")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if editType == .create {
                            planUseCase.execute(action: .createPlan(plan))
                        } else if editType == .update {
                            planUseCase.execute(action: .updatePlan(plan.id, plan))
                        }
                        planUseCase.execute(action: .readPlan)
                        dismiss()
                    } label: {
                        Text("완료")
                    }
                }
            }
        }
    }
}

#Preview {
    PlanSheetView(plan: .init(), editType: .update, planUseCase: .constant(PlanUseCase(dataService: DataService.shared)))
}
