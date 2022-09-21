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
    func toJsonString(_ serveInfo: ServeInfo) -> String?
    func fetchWeather(completion: (ReceiveInfo?) -> ())
    func getWeatherIcon(_ receiveInfo: ReceiveInfo?) -> UIImage?
}


//処理内容を記した、処理を任されるクラスその1
class YumemiForecast: ForecastProtocol {
    
    var errorMessage: String?
    
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
        if let jsonDataExist = jsonData {
            let jsonString = String(data: jsonDataExist, encoding: .utf8)!
            return jsonString
        } else {
            return nil
        }
    }
    
    //API取得、デコード
    func fetchWeather(completion: (ReceiveInfo?) -> ()) {
        var weather: String?
        errorMessage = nil
        var receiveInfo: ReceiveInfo? = nil
        do {
            //オブジェクトからJson形式へ変換（エンコード）
            //↓ DateFormatter() かつ dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" でも対応可能
            let dateFormatter = ISO8601DateFormatter()
            let dtString: String = dateFormatter.string(from: Date())
            let jsonString = toJsonString(ServeInfo(area: "tokyo", date: dtString))
            if let jsonStringExist = jsonString {
                //Json文字列を引数にAPI呼び出し、天気取得
                try weather = YumemiWeather.syncFetchWeather(jsonStringExist)
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
        completion(receiveInfo)
    }
    
    //画像を取得
    func getWeatherIcon(_ receiveInfo: ReceiveInfo?) -> UIImage? {
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
            print("receiveInfoは存在しません")
            return nil
        }
    }
    
}

//実際に処理が動くクラス(画面)
class ViewController: UIViewController {
    
    @IBOutlet var weather: UIImageView!
    @IBOutlet var maxTemperature: UILabel!
    @IBOutlet var minTemperature: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = .red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleWillEnterForeground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private var defaultForecast: ForecastProtocol = YumemiForecast()
    var receiveInfo: ReceiveInfo?
    var weatherIcon: UIImage?
    
    func updateForecast(_ forecast: ForecastProtocol) {
        forecast.fetchWeather { rInfo in
            receiveInfo = rInfo
            weatherIcon = forecast.getWeatherIcon(receiveInfo)
        }
    }
    
    func displayForecast(_ forecast: ForecastProtocol) {
        //exceptionルートを通っていたらUIArertControllerでエラー表示
        if let message = forecast.errorMessage {
            //UIAlertController生成クラスの呼び出し
            let createAlertController = CreateAlertController()
            let alertController = createAlertController.create(message)
            // UIAlertControllerの表示
            present(alertController, animated: true, completion: nil)
            return
        }
        //通っていなかったら取得情報のラベル等への埋め込み
        if let receiveInfoExist = receiveInfo {
            if let weatherIcon = weatherIcon {
                weather.image = weatherIcon
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date.text = "\(dateFormatter.string(from: receiveInfoExist.date))"
            maxTemperature.text = "\(receiveInfoExist.maxTemperature)"
            minTemperature.text = "\(receiveInfoExist.minTemperature)"
        }
    }
    
    func forecastHandler() {
        activityIndicator.startAnimating()
        //startAnimating()を実行させる猶予時間を設定
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            if let dForecast = self?.defaultForecast {
                self?.updateForecast(dForecast)
                self?.displayForecast(dForecast)
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    //バックグラウンドからフォアグラウンドに戻った際に実行される処理
    @objc func handleWillEnterForeground(notification: Notification) {
        forecastHandler()
    }
    
    //Reloadボタンが押下された際に実行される処理
    @IBAction func reloadButtonTapped(_ sender: Any) {
        forecastHandler()
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
