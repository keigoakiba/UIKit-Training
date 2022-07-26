//
//  TableViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/09/28.
//

import UIKit
import YumemiWeather

//このテーブルビュー自体とストーリーボードとを紐づけているのは？？
class TableViewController: UITableViewController {
    
    private var defaultForecast: ForecastProtocol = YumemiForecast()
    var receiveInfoList: [InfoSet]?
    var weatherIcon: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultForecast.fetchWeatherList { iSet in
            receiveInfoList = iSet
        }
        
    }

    // MARK: - Table view data source
    //テーブルの詳細内容

    //セクション数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //セクションの中のセル数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveInfoList?.count ?? 1
    }

    //セルの詳細内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        guard let infoList = receiveInfoList?[indexPath.row] else {
            let errorText = cell.viewWithTag(1) as! UILabel
            errorText.text = "エラー発生"
            return cell
        }
        
        let area = cell.viewWithTag(1) as! UILabel
        area.text = infoList.area
        
        let maxTemp = cell.viewWithTag(2) as! UILabel
        maxTemp.text = String(infoList.info.maxTemperature)

        let minTemp = cell.viewWithTag(3) as! UILabel
        minTemp.text = String(infoList.info.minTemperature)
        
        let weatherIcon = defaultForecast.getWeatherIcon(infoList.info)
        let weather = cell.viewWithTag(4) as! UIImageView
        weather.image = weatherIcon
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    //セルの形とかセル押された時の処理とか
    
    // セルがタップされた時の処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard!
        if let nextView = storyboard.instantiateViewController(withIdentifier: "forecastScreen") as? ViewController {
            nextView.infoSet = receiveInfoList?[indexPath.row]
            navigationController?.pushViewController(nextView, animated: true)
        }
    }

}
