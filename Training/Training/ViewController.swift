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
    func fetchWeather() -> UIImage?
}

//処理内容を記したクラス
class Detail: ButtonDelegate {
    
    /*
    var sunnyIcon = UIImage(named: "sunny")?.withTintColor(UIColor.red)
    var cloudyIcon = UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
    var rainyIcon = UIImage(named: "rainy")?.withTintColor(UIColor.blue)
    */
     
    func fetchWeather() -> UIImage? {
        print("目印")
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

//実際に処理が動くクラス
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet var weatherIcon: UIImageView!
    
    @IBAction func fetchWeather(_ sender: Any) {
        let detail = Detail()
        let weatherIconBase: UIImage? = detail.fetchWeather()
        weatherIcon.image = weatherIconBase!
    
    }
    
    @IBAction func closeViewCon() {
           self.dismiss(animated: true, completion: nil)
       }
    
}

