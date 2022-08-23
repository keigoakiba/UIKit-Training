//
//  ViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/26.
//

import UIKit
import YumemiWeather
import Foundation

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
    func toJsonString(_ serveInfo: ServeInfo) -> String?
    func fetchWeather()
    func getWeatherIcon() -> UIImage?
}

//AlertController表示に使用する変数
var errorMessage: String?
//取得した情報(オブジェクト形式)を格納する変数
var receiveInfo: ReceiveInfo? = nil

//処理内容を記した、処理を任されるクラスその1
class YumemiForecast: forecastDelegate {
    
    //オブジェクトからJson形式へ変換（エンコード）
    func toJsonString(_ serveInfo: ServeInfo) -> String? {
        var jsonData: Data?
        let encoder = JSONEncoder()
        do {
            jsonData = try encoder.encode(serveInfo)
        } catch {
            errorMessage = "予期せぬエラーが発生しました"
            print(error)
            return nil
        }
        if let jsonData = jsonData {
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } else {
            return nil
        }
    }
    
    //API取得、デコード
    func fetchWeather() {
        var weather: String?
        do {
            errorMessage = nil
            receiveInfo = nil
            //オブジェクトからJson形式へ変換（エンコード）
            let jsonString = toJsonString(ServeInfo(area: "tokyo", date: "2020-04-01T12:00:00+09:00"))
            if let jsonString = jsonString {
                //Json文字列を引数にAPI呼び出し、天気取得
                try weather = YumemiWeather.fetchWeather(jsonString)
            }
            //受け取ったJson文字列をオブジェクトに変換（デコード）
            var jsonData: Data?
            if let weatherData = weather {
                jsonData = weatherData.data(using: .utf8)!
            }
            if let jsonData = jsonData {
                receiveInfo = try JSONDecoder().decode(ReceiveInfo.self, from: jsonData)
            }
        } catch (YumemiWeatherError.invalidParameterError) {
            errorMessage = "invalidParameterErrorが発生しました"
        } catch (YumemiWeatherError.unknownError) {
            errorMessage = "unknownErrorが発生しました"
        } catch {
            errorMessage = "予期せぬエラーが発生しました"
            print(error)
        }
    }
    
    //画像を取得
    func getWeatherIcon() -> UIImage? {
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
    
    func doFetchWeather()  {
        if let dg = self.delegate {
            return dg.fetchWeather()
        } else {
            print("delegate実行不可")
        }
    }
    
}

//実際に処理が動くクラス(画面)
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var weather: UIImageView!
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var minTemperature: UILabel!
    
    @IBAction func fetchWeather(_ sender: Any) {
        var weatherIcon: UIImage? = nil
        //処理を任せるクラスのインスタンス生成
        let forecast = Forecast()
        //今回処理を任されるクラスのインスタンス生成 と紐付け
        let yumemiForecast = YumemiForecast()
        forecast.delegate = yumemiForecast
        forecast.doFetchWeather()
        
        //exceptionルートを通っていたらUIArertControllerでエラー表示
        if let message = errorMessage  {
            //UIAlertController生成クラスの呼び出し
            let createAlertController = CreateAlertController()
            let alertController = createAlertController.create(message)
            // UIAlertControllerの表示
            present(alertController, animated: true, completion: nil)
        } else {
            //exceptionのルートを通っていなかったら天気画像等を表示
            if let receiveInfoExist = receiveInfo {
            weatherIcon = yumemiForecast.getWeatherIcon()
            if let icon = weatherIcon {
                weather.image = icon
            }
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
