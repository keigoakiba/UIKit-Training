//
//  ViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/26.
//

import UIKit
import YumemiWeather

/*
var sunnyIcon : UIImage!
var cloudyIcon : UIImage!
var rainyIcon : UIImage!
*/
 

//プロトコル
protocol ButtonDelegate {
    func fetchWeather() -> UIImageView
}

//処理内容を記したクラス
class Detail: ButtonDelegate {
    
    var sunnyIcon = UIImage(named: "sunny")?.withTintColor(UIColor.red)
    var cloudyIcon = UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
    var rainyIcon = UIImage(named: "rainy")?.withTintColor(UIColor.blue)

    private var weatherIconBase: UIImageView!
    
    func fetchWeather() -> UIImageView {
        print("目印")
        print(sunnyIcon)
        let weather = YumemiWeather.fetchWeatherCondition()
        switch weather {
        case "sunny":
            weatherIconBase.image = sunnyIcon
            return weatherIconBase
        case "cloudy":
            weatherIconBase.image = cloudyIcon
            return weatherIconBase
        case "rainy":
            weatherIconBase.image = rainyIcon
            return weatherIconBase
        default:
            weatherIconBase.image = sunnyIcon
            return weatherIconBase
        }
    }
}

//実際に処理が動くクラス
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet var weatherIcon: UIImageView!
    
    @IBAction func fetchWeather(_ sender: Any) {
        let detail = Detail()
        let weatherIconBase = detail.fetchWeather()
        weatherIcon = weatherIconBase
    
    }
    
    @IBAction func closeViewCon() {
           self.dismiss(animated: true, completion: nil)
       }
    
}

