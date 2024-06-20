//
//  MainView+WeatherDetail.swift
//  WeatherPlan
//
//  Created by Yunki on 6/20/24.
//

import SwiftUI

extension MainView {
    struct WeatherDetailView: View {
        @Binding var weatherUseCase: WeatherUseCase
        @Binding var planUseCase: PlanUseCase
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    if let data = weatherUseCase.state.model[planUseCase.state.currentDate.beginOfDate] {
                        HStack {
                            Text("\(data.lowTemperature)º")
                            RoundedRectangle(cornerRadius: 21)
                                .frame(width: 50,height: 4)
                                .foregroundStyle(LinearGradient(colors: [.gradientBlue, .gradientRed], startPoint: .leading, endPoint: .trailing))
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
        }
    }
}
