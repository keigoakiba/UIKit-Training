//
//  ViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/26.
//

import UIKit
import YumemiWeather

//APIに渡すJson文字列の器
struct ServeInfo: Encodable {
    var area: String
    var date: String
}

//APIから受け取るJson文字列の器
struct ReceiveInfo: Decodable {
    var weather_condition: String
    var max_temperature:Int
    var min_temperature: Int
    var date: String
}

//プロトコル
protocol forecastDelegate: AnyObject {
    func fetchWeather() -> UIImage?
}

//AlertController表示に使用する変数
var errorMessage: String? = nil
//取得した情報(オブジェクト形式)を格納する変数
var receiveInfo: ReceiveInfo? = nil

//処理内容を記した、処理を任されるクラスその1
class Detail: forecastDelegate {
    
    func fetchWeather() -> UIImage? {
        var weather: String?
        do {
            //オブジェクトからJson形式へ変換（エンコード）
            let serveInfo = ServeInfo(area: "tokyo", date: "2020-04-01T12:00:00+09:00")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            var jsonData = try encoder.encode(serveInfo)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            //Json文字列を引数にAPI呼び出し、天気取得
            try weather = YumemiWeather.fetchWeather(jsonString)
            //受け取ったJson文字列をオブジェクトに変換（デコード）
            if let weatherData = weather {
                jsonData = weatherData.data(using: .utf8)!
            }
            receiveInfo = try JSONDecoder().decode(ReceiveInfo.self, from: jsonData)
        } catch (YumemiWeatherError.invalidParameterError) {
            errorMessage = "invalidParameterErrorが発生しました"
            return nil
        } catch (YumemiWeatherError.unknownError) {
            errorMessage = "unknownErrorが発生しました"
            return nil
        } catch {
            errorMessage = "予期せぬエラーが発生しました"
            print(error)
            return nil
        }
        if let weatherResult = receiveInfo {
            switch weatherResult.weather_condition {
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
    
    func click() -> UIImage? {
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
        
        // alert.present(alert, animated: true, completion: nil)
        return alert
    }
    
}

//実際に処理が動くクラス(画面)
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var minTemperature: UILabel!
    
    @IBAction func fetchWeather(_ sender: Any) {
        //処理を任せるクラスのインスタンス生成
        let forecast = Forecast()
        //今回処理を任されるクラスのインスタンス生成 と紐付け
        let detail = Detail()
        forecast.delegate = detail
        
        let weatherIconBase: UIImage?
        weatherIconBase = forecast.click()
        
        //exceptionルートを通っていたらUIArertControllerでエラー表示
        if let message = errorMessage  {
            //UIAlertController生成クラスの呼び出し
            let createAlertController = CreateAlertController()
            let alertController = createAlertController.create(message)
            // UIAlertControllerの表示
            present(alertController, animated: true, completion: nil)
        } else {
            //exceptionのルートを通っていなかったら天気画像と気温テキストを表示
            if let iconCheck = weatherIconBase {
                weatherIcon.image = iconCheck
            }
            if let receiveInfoExist = receiveInfo {
                maxTemperature.text = "\(receiveInfoExist.max_temperature)"
                minTemperature.text = "\(receiveInfoExist.min_temperature)"
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
