//
//  TrainingUnitTests.swift
//  TrainingTests
//
//  Created by 秋庭圭吾 on 2022/09/08.
//

import XCTest
@testable import Training

class TrainingUnitTests: XCTestCase {

    func test天気予報がsunnyだったら晴れ画像を表示する() throws {
        let expectImage = UIImage(named: "sunny")?.withTintColor(UIColor.red)
        let vc = ViewController()
        vc.updateForecast(Sunny())
        let actualImage: UIImage? = vc.weatherIcon
        XCTAssertEqual(expectImage, actualImage)  //XCTAssertTrue(expectImage!.isEqual(actualImage))でも可
    }
    
    func test天気予報がcloudyだったら曇り画像を表示する() throws {
        let expectImage = UIImage(named: "cloudy")?.withTintColor(UIColor.gray)
        let vc = ViewController()
        vc.updateForecast(Cloudy())
        let actualImage: UIImage? = vc.weatherIcon
        XCTAssertEqual(expectImage, actualImage)  //XCTAssertTrue(expectImage!.isEqual(actualImage))でも可
    }
    
    func test天気予報がrainyだったら雨画像を表示する() throws {
        let expectImage = UIImage(named: "rainy")?.withTintColor(UIColor.blue)
        let vc = ViewController()
        vc.updateForecast(Rainy())
        let actualImage = vc.weatherIcon
        XCTAssertEqual(expectImage, actualImage)  //XCTAssertTrue(expectImage!.isEqual(actualImage))でも可
    }
    
    func test最高気温をラベルに反映する() throws {
        let expectMaxTemp = 30
        let vc = ViewController()
        vc.updateForecast(MaxTemperature())
        let actualMaxTemp = vc.receiveInfo?.maxTemperature
        XCTAssertEqual(expectMaxTemp, actualMaxTemp)
    }
    
    func test最低気温をラベルに反映する() throws {
        let expectMinTemp = 0
        let vc = ViewController()
        vc.updateForecast(MinTemperature())
        let actualMinTemp = vc.receiveInfo?.minTemperature
        XCTAssertEqual(expectMinTemp, actualMinTemp)
    }

}
