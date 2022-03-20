//
//  WeatherViewModel.swift
//  Wedar
//
//  Created by Miguel Gutiérrez Pardo on 9/3/22.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var celsius: String = ""
    @Published var textColor: Color = Color.white
    @Published var cityName: String = ""
    @Published var descriptionWeather: String = ""
    @Published var isLoading: Bool = true
    @Published var background:String = ""
    @Published var lat: Double = 0.0
    @Published var lon: Double = 0.0
    @Published var imageWeather = ""
    @ObservedObject var locationManager = LocationManager()
    
    func getLatLong(){
        if let location = locationManager.location{
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
            fetchCurrentWeather(lat: lat, lon: lon)
            setBackground()
        }
    }
    
    func fetchCurrentWeather(lat:Double, lon: Double){
        let APIKEY = "5ef89565d430ef9aa474f4b8fc785b59"
        let url = URL(string:
                        "https:api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(APIKEY)")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!, completionHandler: handle(data:response:error:))
        task.resume()
    }
    
    func handle (data:Data?, response:URLResponse?, error:Error?) {
        if error != nil{
            print(error!)
            return
        }
        
        if let safeData = data {
            
            DispatchQueue.main.async {
                let request : Request = try! JSONDecoder().decode(Request.self, from: safeData)
                self.cityName = request.name
                self.celsius = String(format: "%.1f",request.main.temp)
                self.imageWeather = "https://openweathermap.org/img/wn/\(request.weather[0].icon)@2x.png"
                
                self.descriptionWeather = request.weather[0].weatherDescription.capitalized
            }
            self.isLoading = false
            
        }
    }
    func setBackground () {
        let today = Date()
        
        let hours   = (Calendar.current.component(.hour, from: today))
        
        switch hours{
        case 0...10:
            self.background = "dayBg"
        case 11...18:
            self.background = "midBg"
        case 19...23:
            self.background = "nightBg"
        default:
            self.background = "dayBg"
        }
        
    }
}
