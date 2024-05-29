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
            Text("Weather:")
            Text("region: \(viewModel.weatherInfo.region)")
            Text("pressureMB: \(viewModel.weatherInfo.pressureMB)")
            Text("tempC: \(viewModel.weatherInfo.tempC)")
            Text("windKph: \(viewModel.weatherInfo.windKph)")
            Text("precipitation: \(viewModel.weatherInfo.precipitation)")
        }
        .padding()
        .onAppear {
            viewModel.observeCoordinateUpdates()
            viewModel.observeLocationAccessDenied()
            viewModel.requestLocationUpdates()
        }
    }
}

#Preview {
    ContentView()
}
