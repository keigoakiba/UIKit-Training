//
//  CreateAlert.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/08/22.
//

import Foundation
import UIKit

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
