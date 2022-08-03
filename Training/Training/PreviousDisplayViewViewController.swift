//
//  PreviousDisplayViewViewController.swift
//  Training
//
//  Created by 秋庭圭吾 on 2022/07/29.
//

import UIKit

class PreviousDisplayViewViewController: UIViewController {

    //viewを読み込んだ後に動く処理
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
    }
    
    //viewを表示しきった後に動く処理
    override func viewDidAppear(_ animated: Bool) {
        //storyboardIDで画面紐付け
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "forecastScreen")
        //nilチェックしてフルスクリーン設定と画面遷移処理
        if let next = nextViewController {
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
