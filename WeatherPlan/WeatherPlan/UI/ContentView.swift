//
//  ContentView.swift
//  WeatherPlan
//
//  Created by Yunki on 6/14/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
//    @State var weatherModels: [WeatherModel] = []
    @State var weatherManager = WeatherManager()
    
    var body: some View {
        VStack{
            ForEach(weatherManager.weatherModels){ weatherModel in
                HStack{
                    Text("\(weatherModel.date)")
                    Image(systemName: weatherModel.symbolName)
                }
            }
        }
        .onAppear{
        _ = weatherManager.fetchWeather(location: CLLocation(latitude: 36.0135, longitude: 129.3263))
        }
    }
}

#Preview {
    ContentView()
}
