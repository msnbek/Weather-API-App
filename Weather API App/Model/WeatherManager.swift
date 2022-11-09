//
//  WeatherManager.swift
//  Weather API App
//
//  Created by Mahmut Şenbek on 9.11.2022.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=8c6921a7015882765538806b35f4c1a1&units=metric")
    
    var delegate : WeatherManagerDelegate?
    
    func fentchWeather(cityName: String) {
        
        let urlString = "\(weatherURL!)&q=\(cityName)"
        
        performRequest(urlString: urlString)
        
    }
    
    func fentchWeather(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        
        let urlString = "\(weatherURL!)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if  let testUrl = URL(string: urlString) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: testUrl) { data, response, error in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
               
                    return
                
                }
                if let newData = data {
                    DispatchQueue.main.sync {
                        if let weather = self.parseJson(weatherData: newData) {
                            self.delegate?.didUpdateWeather(weather: weather)
                        }
                    }
                    
                }
                
            }
            task.resume()
        }
    }
        
        func parseJson(weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do{
             let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            let temp = String(format: "%.1f", decodedData.main.temp)
                print(temp)
            let id = (decodedData.weather[0].id)
            let sys = (decodedData.sys.country)
                let name = (decodedData.name)
                let lon = decodedData.coord.lon
                let lat = decodedData.coord.lat
                print(lon)
                print(lat)
                
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, sys: sys,lon: lon,lat: lat)
               return weather
        
            }catch {
                
                delegate?.didFailWithError(error: error)
                return nil
               
            }
            
        }
      
}

