//
//  ViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/26.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    var icon : UIImage!
    var icon2 : UIImage!
    var icon3 : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon = UIImage(named: "sunny")
        icon2 = UIImage(named: "cloudy")
        icon3 = UIImage(named: "rainy")
        
    }
    
    @IBAction func fetchWeather(_ sender: Any) {
        let weather = YumemiWeather.fetchWeatherCondition()
        switch weather {
        case "sunny":
            weatherIcon.image = icon
        case "cloudy":
            weatherIcon.image = icon2
        case "rainy":
            weatherIcon.image = icon3
        default:
            weatherIcon.image = icon
        }
    
    }

}
