//
//  WeatherData.swift
//  Weather API App
//
//  Created by Mahmut Şenbek on 9.11.2022.
//

import Foundation


struct WeatherData: Codable {
    let name : String
    let main : Main
    let weather : [Weather]
    let sys : Sys
    let coord : Coord
}

struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    
    let id: Int
    
}

struct Sys: Codable {
    
    let country: String
}

struct Coord: Codable {
    
    let lon : Double
    let lat : Double
}
