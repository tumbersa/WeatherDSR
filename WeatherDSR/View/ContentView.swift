//
//  ContentView.swift
//  WeatherDSR
//
//  Created by Глеб Капустин on 28.05.2024.
//

import SwiftUI

struct ContentView: View {
   
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Current weather:")
            Text("region: \(viewModel.weatherInfo.region)")
            Text("pressureMB: \(viewModel.weatherInfo.pressureMB)")
            Text("tempC: \(viewModel.weatherInfo.tempC)")
            Text("windKph: \(viewModel.weatherInfo.windKph)")
            Text("precipitation: \(viewModel.weatherInfo.precipitation)")
            
            let rows = [GridItem(.flexible())]
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows) {
                    ForEach(viewModel.forecastInfo.prefix(5), id: \.date) { infoItem in
                        ForecastViewCell(infoItem: infoItem)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.observeCoordinateUpdates()
            viewModel.observeLocationAccessDenied()
            viewModel.requestLocationUpdates()
        }
    }
}

struct ForecastViewCell: View {
    
    private var infoItem: ForecastInfo
    
    var body: some View {
        VStack {
            Text("\(infoItem.date)")
            Text("\(infoItem.tempC) °C")
            Text("\(infoItem.precipitation) mm")
        }
        .padding()
    }
    
    init(infoItem: ForecastInfo) {
        self.infoItem = infoItem
    }
}

#Preview {
    ContentView()
}
