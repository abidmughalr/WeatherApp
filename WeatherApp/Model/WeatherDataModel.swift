//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Abid Mughal on 9/11/24.
//

import Foundation

struct Weather: Codable {
    let name: String
    let main: TemperatureDetails
    let weather: [WeatherDetail]
}

struct TemperatureDetails: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherDetail: Codable {
    let description: String
    let icon: String
}

