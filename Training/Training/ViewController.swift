//
//  ViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/26.
//

import UIKit
import YumemiWeather

//AlertController表示に使用する変数
var errorMessage: String?

//プロトコル
protocol forecastDelegate: AnyObject {
    func fetchWeather() -> UIImage?
}

//処理内容を記した、処理を任されるクラスその1
class YumemiForecast: forecastDelegate {
    
    func fetchWeather() -> UIImage? {
        var weather: String?
        do {
            errorMessage = nil
            try weather = YumemiWeather.fetchWeatherCondition(at: "tokyo")
        } catch (YumemiWeatherError.invalidParameterError) {
            errorMessage = "invalidParameterErrorが発生しました"
            return nil
        } catch (YumemiWeatherError.unknownError) {
            errorMessage = "unknownErrorが発生しました"
            return nil
        } catch {
            errorMessage = "予期せぬエラーが発生しました"
            return nil
        }
        if let weatherNotNil = weather {
            switch weatherNotNil {
            case "sunny":
                return UIImage(named: "sunny")?.withTintColor(UIColor.red)
            case "cloudy":
                return UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
            case "rainy":
                return UIImage(named: "rainy")?.withTintColor(UIColor.blue)
            default:
                return UIImage(named: "sunny")?.withTintColor(UIColor.red)
            }
        } else {
            return nil
        }
    }
    
}

//処理を任せるクラス
class Forecast {
    //weak必須
    weak var delegate: forecastDelegate? = nil
    
    func doFetchWeather() -> UIImage? {
        if let dg = self.delegate {
            return dg.fetchWeather()
        } else {
            return nil
        }
    }
    
}

//UIArertControllerを生成するクラス
class CreateAlertController {
    
    func create (_ message: String) -> UIAlertController {
        // UIAlertControllerの生成
        let alert = UIAlertController(title: message, message: "再試行してください", preferredStyle: .alert)
        // アクションの生成
        let yesAction = UIAlertAction(title: "了解", style: .default) { action in
            //追加処理なし
        }
        let noAction = UIAlertAction(title: "納得できません", style: .destructive) { action in
            //追加処理なし
        }
        // アクションの追加
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        return alert
    }
}

//実際に処理が動くクラス(画面)
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var weather: UIImageView!
    
    @IBAction func fetchWeather(_ sender: Any) {
        //処理を任せるクラスのインスタンス生成
        let forecast = Forecast()
        //今回処理を任されるクラスのインスタンス生成 と紐付け
        let yumemiForecast = YumemiForecast()
        forecast.delegate = yumemiForecast
        let weatherIcon: UIImage? = forecast.doFetchWeather()
        
        //exceptionルートを通っていたらUIArertControllerでエラー表示
        if let message = errorMessage  {
            //UIAlertController生成クラスの呼び出し
            let createAlertController = CreateAlertController()
            let alertController = createAlertController.create(message)
            // UIAlertControllerの表示
            present(alertController, animated: true, completion: nil)
        } else {
            //exceptionのルートを通っていなかったら天気画像を表示
            if let icon = weatherIcon {
                weather.image = icon
            }
        }
    }
    
    //天気予報画面を閉じる
    @IBAction func closeViewCon() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //ログ出力
    deinit {
        let dt: Date = Date()
        print(dt)
    }
    
}
