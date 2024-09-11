//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Abid Mughal on 9/11/24.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var city: String = ""
    @Published var temperature: String = ""
    @Published var weatherDescription: String = ""
    @Published var icon: String = ""
    @Published var humidity: String = ""
    
    private let locationManager = CLLocationManager()
    private let apiKey = "f47747d5996e5e8774eda3505ded653f" //(this api key i get from  openweathermap.org)
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    // Fetch weather data by city name
    func fetchWeather(for city: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(Weather.self, from: data) {
                    DispatchQueue.main.async {
                        self.city = weatherData.name
                        self.temperature = "\(Int(weatherData.main.temp)) °C"
                        self.weatherDescription = weatherData.weather.first?.description ?? ""
                        self.icon = weatherData.weather.first?.icon ?? ""
                        self.humidity = "\(weatherData.main.humidity)% Humidity"
                    }
                }
            }
        }.resume()
    }
    
    // Request user location
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            fetchWeatherByCoordinates(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
    
    // Fetch weather by coordinates
    func fetchWeatherByCoordinates(lat: Double, lon: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(Weather.self, from: data) {
                    DispatchQueue.main.async {
                        self.city = weatherData.name
                        self.temperature = "\(Int(weatherData.main.temp)) °C"
                        self.weatherDescription = weatherData.weather.first?.description ?? ""
                        self.icon = weatherData.weather.first?.icon ?? ""
                        self.humidity = "\(weatherData.main.humidity)% Humidity"
                    }
                }
            }
        }.resume()
    }
}
