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
struct ServeInfo: Codable {
    var area: String
    var date: String
}

//APIから受け取るJson文字列の器
struct ReceiveInfo: Codable {
    var weatherCondition: String
    var maxTemperature: Int
    var minTemperature: Int
    var date: Date
    
    //Swift命名規則に則る変数で受け取るための列挙型
    enum CodingKeys: String, CodingKey {
        case weatherCondition = "weather_condition"
        case maxTemperature = "max_temperature"
        case minTemperature = "min_temperature"
        case date = "date"
    }
    
}

//プロトコル
protocol ForecastProtocol: AnyObject {
    //AlertController表示に使用する変数
    var errorMessage: String? { get }
    //取得した情報(オブジェクト形式)を格納する変数
    var receiveInfo: ReceiveInfo? { get }
    func toJsonString(_ serveInfo: ServeInfo) -> String?
    func fetchWeather()
    func getWeatherIcon() -> UIImage?
}


//処理内容を記した、処理を任されるクラスその1
class YumemiForecast: ForecastProtocol {
    
    var errorMessage: String?
    var receiveInfo: ReceiveInfo?
    
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
            //↓ DateFormatter() かつ dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" でも対応可能
            let dateFormatter = ISO8601DateFormatter()
            let dtString: String = dateFormatter.string(from: Date())
            let jsonString = toJsonString(ServeInfo(area: "tokyo", date: dtString))
            if let jsonString = jsonString {
                //Json文字列を引数にAPI呼び出し、天気取得
                try weather = YumemiWeather.fetchWeather(jsonString)
            }
            //受け取ったJson文字列をオブジェクトに変換（デコード）
            guard let weatherData = weather else {
                return
            }
            let jsonData = weatherData.data(using: .utf8)!
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            receiveInfo = try decoder.decode(ReceiveInfo.self, from: jsonData)
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
            switch weatherResult.weatherCondition {
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
    private var impl: ForecastProtocol? = nil
    
    init (_ selectedClass: ForecastProtocol) {
        self.impl = selectedClass
    }
    
    func doFetchWeather()  {
        if let dg = self.impl {
            return dg.fetchWeather()
        } else {
            print("delegate実行不可")
        }
    }
    
    func doGetWeatherIcon() -> UIImage? {
        if let dg = self.impl {
            return dg.getWeatherIcon()
        } else {
            print("delegate実行不可")
            return nil
        }
    }
    
    //errorMessageを返すメソッド
    func errorMessage() -> String? {
        return impl?.errorMessage
    }
    
    //receiveIndoを返すメソッド
    func receiveInfo() -> ReceiveInfo? {
        return impl?.receiveInfo
    }
    
}

//実際に処理が動くクラス(画面)
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(handleWillEnterForeground(notification:)),
                                                name: UIApplication.willEnterForegroundNotification,
                                                object: nil)
    }
    
    @IBOutlet var weather: UIImageView!
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var minTemperature: UILabel!
    @IBOutlet var date: UILabel!
    
    func updateForecast() {
        var weatherIcon: UIImage? = nil
        //処理を任せるクラスのインスタンス生成と今回処理を任されるクラスの紐付け
        let forecast = Forecast(YumemiForecast())
        forecast.doFetchWeather()
        
        //exceptionルートを通っていたらUIArertControllerでエラー表示
        if let message = forecast.errorMessage()  {
            //UIAlertController生成クラスの呼び出し
            let createAlertController = CreateAlertController()
            let alertController = createAlertController.create(message)
            // UIAlertControllerの表示
            present(alertController, animated: true, completion: nil)
            return
        }
        //exceptionのルートを通っていなかったら天気画像を取得し、日時・気温とともに表示
        if let receiveInfoExist = forecast.receiveInfo() {
            weatherIcon = forecast.doGetWeatherIcon()
            if let icon = weatherIcon {
                weather.image = icon
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date.text = "\(dateFormatter.string(from: receiveInfoExist.date))"
            maxTemperature.text = "\(receiveInfoExist.maxTemperature)"
            minTemperature.text = "\(receiveInfoExist.minTemperature)"
        }
    }
    
    //バックグラウンドからフォアグラウンドに戻った際に実行される処理
    @objc func handleWillEnterForeground(notification: Notification) {
        updateForecast()
    }
    
    //Reloadボタンが押下された際に実行される処理
    @IBAction func reloadButtonTapped(_ sender: Any) {
        updateForecast()
    }
    
    //天気予報画面を閉じる
    @IBAction func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //ログ出力
    deinit {
        let dt: Date = Date()
        print(dt)
    }
    
}
