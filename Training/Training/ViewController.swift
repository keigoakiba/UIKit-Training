//
//  ViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/26.
//

import UIKit
import YumemiWeather
 

//プロトコル
protocol forecastDelegate: AnyObject {
    func fetchWeather() -> UIImage?
}

//処理内容を記した、処理を任されるクラスその1
class Detail: forecastDelegate {
    
    func fetchWeather() -> UIImage? {
        let weather = YumemiWeather.fetchWeatherCondition()
        switch weather {
        case "sunny":
            return UIImage(named: "sunny")?.withTintColor(UIColor.red)
        case "cloudy":
            return UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
        case "rainy":
            return UIImage(named: "rainy")?.withTintColor(UIColor.blue)
        default:
            return UIImage(named: "sunny")?.withTintColor(UIColor.red)
        }
    }
    
}

//処理を任せるクラス
class Forecast {
    
    //weak必須
    weak var delegate: forecastDelegate? = nil
    
    func click() -> UIImage? {
            if let dg = self.delegate {
                return dg.fetchWeather()
            } else {
                return nil
            }
        }
    
}

//実際に処理が動くクラス(画面)
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var weatherIcon: UIImageView!
    
    @IBAction func fetchWeather(_ sender: Any) {
        //処理を任せるクラスのインスタンス生成
        let forecast = Forecast()
        //今回処理を任されるクラスのインスタンス生成 と紐付け
        let detail = Detail()
        forecast.delegate = detail
        
        let weatherIconBase: UIImage? = forecast.click()
        if let iconCheck = weatherIconBase {
            weatherIcon.image = iconCheck
        }
    }
    
    @IBAction func closeViewCon() {
           self.dismiss(animated: true, completion: nil)
       }

}

