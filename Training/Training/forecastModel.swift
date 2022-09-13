//
//  forecastModel.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/09/12.
//

import Foundation
import UIKit

class Sunny: ForecastProtocol {
    
    var errorMessage: String?
    var receiveInfo: ReceiveInfo?
    
    func toJsonString(_ serveInfo: ServeInfo) -> String? {
        return nil
    }
    
    func fetchWeather() {
        
    }
    
    func getWeatherIcon() -> UIImage? {
        return UIImage(named: "sunny")?.withTintColor(UIColor.red)
    }
    
}

class Cloudy: ForecastProtocol {
    
    var errorMessage: String?
    var receiveInfo: ReceiveInfo?
    
    func toJsonString(_ serveInfo: ServeInfo) -> String? {
        return nil
    }
    
    func fetchWeather() {
        
    }
    
    func getWeatherIcon() -> UIImage? {
        return UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
    }
    
}

class Rainy: ForecastProtocol {
    
    var errorMessage: String?
    var receiveInfo: ReceiveInfo?
    
    func toJsonString(_ serveInfo: ServeInfo) -> String? {
        return nil
    }
    
    func fetchWeather() {
        
    }
    
    func getWeatherIcon() -> UIImage? {
        return UIImage(named: "rainy")?.withTintColor(UIColor.blue)
    }
    
}


class MaxTemperature: ForecastProtocol {
    
    var errorMessage: String?
    var receiveInfo: ReceiveInfo?
    
    func toJsonString(_ serveInfo: ServeInfo) -> String? {
        return nil
    }
    
    func fetchWeather() {
        receiveInfo = ReceiveInfo(weatherCondition: "sunny", maxTemperature: 30, minTemperature: 10, date: Date())
    }
    
    func getWeatherIcon() -> UIImage? {
        return nil
    }
    
}

class MinTemperature: ForecastProtocol {
    
    var errorMessage: String?
    var receiveInfo: ReceiveInfo?
    
    func toJsonString(_ serveInfo: ServeInfo) -> String? {
        return nil
    }
    
    func fetchWeather() {
        receiveInfo = ReceiveInfo(weatherCondition: "sunny", maxTemperature: 20, minTemperature: 0, date: Date())
    }
    
    func getWeatherIcon() -> UIImage? {
        return nil
    }
    
}

