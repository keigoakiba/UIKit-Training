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
    private var sunnyIcon : UIImage!
    private var cloudyIcon : UIImage!
    private var rainyIcon : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sunnyIcon = UIImage(named: "sunny")?.withTintColor(UIColor.red)
        cloudyIcon = UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
        rainyIcon = UIImage(named: "rainy")?.withTintColor(UIColor.blue)
        
    }
    
    @IBAction func fetchWeather(_ sender: Any) {
        let weather = YumemiWeather.fetchWeatherCondition()
        switch weather {
        case "sunny":
            weatherIcon.image = sunnyIcon
        case "cloudy":
            weatherIcon.image = cloudyIcon
        case "rainy":
            weatherIcon.image = rainyIcon
        default:
            weatherIcon.image = sunnyIcon
        }
    
    }

}
