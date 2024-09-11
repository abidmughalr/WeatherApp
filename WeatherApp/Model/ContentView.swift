//
//  ContentView.swift
//  WeatherApp
//
//  Created by Abid Mughal on 9/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var searchCity = ""
    
    var body: some View {
        ZStack {
            // Used this Weather-themed gradient background because white empty background were not looking good.
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Search bar for entering city name
                TextField("Enter city", text: $searchCity, onCommit: {
                    viewModel.fetchWeather(for: searchCity)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white.opacity(0.8))
                
                // Display city name
                Text(viewModel.city)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10) // Make background slightly rounded
                
                // Display weather icon
                if !viewModel.icon.isEmpty {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(viewModel.icon)@2x.png")) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                // Display temperature
                Text(viewModel.temperature)
                    .font(.title)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                
                // Display weather description
                Text(viewModel.weatherDescription)
                    .font(.title3)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                
                // Display humidity
                Text(viewModel.humidity)
                    .font(.subheadline)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .foregroundColor(.black)
        }
        .onAppear {
            viewModel.requestLocation()
        }
    }
}

#Preview {
    ContentView()
}
