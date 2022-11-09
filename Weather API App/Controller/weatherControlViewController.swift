//
//  ViewController.swift
//  Weather API App
//
//  Created by Mahmut Şenbek on 9.11.2022.
//

import UIKit
import CoreLocation

class weatherControlViewController: UIViewController {
  
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherLabel: UIImageView!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    @objc func hiddenKeyboard() {
        view.endEditing(true)
    }
  
   
}


//MARK: - UITextFieldDelegate
extension weatherControlViewController: UITextFieldDelegate {
    
    @IBAction func searchButton(_ sender: UIButton) {
       
        if searchTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please write any city name.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK!", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            present(alert, animated: true)
            
        }else {
            print(searchTextField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please write any city name.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK!", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            present(alert, animated: true)
            return false
        }else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fentchWeather(cityName: city)
            
        }
        
        searchTextField.text = ""
    }
    
    
}

//MARK: - WeatherManagerDelegate
extension weatherControlViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(weather: WeatherModel) {
        
            tempatureLabel.text = "\(weather.temperature)°C"
        cityLabel.text = weather.cityName
        weatherLabel.image = UIImage(systemName: weather.conditionName)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
 
}

//MARK: - LocationManagerDelegate

extension weatherControlViewController: CLLocationManagerDelegate {
    
    @IBAction func getCurrenLocationButton(_ sender: UIButton) {
        
    
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fentchWeather(lon: lon, lat: lat)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}


