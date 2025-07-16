//
//  KyusuiViewController.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/12/16.
//

import UIKit
import AVFoundation

class KyusuiViewController: UIViewController {
    
    
    @IBOutlet weak var timerCountLabel: UILabel!
    //値受け渡し用
    var procData:[String] = []
    //説明文を書くラベル
    @IBOutlet weak var textLabel: UILabel!
        
    var timer:TimerClass!
    
//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デバック用
        print(String(describing: type(of: self)))//現在のクラス名
        print(procData)
        
//        TimerClassのインスタンス作成
        timer = TimerClass(label: timerCountLabel , uiview: self)
        timer.timerSetup(countTime: 1800)
        setLabel()
        timer.timerStart()
  
    }

    func setLabel (){
        self.navigationItem.title = procData[2]
//        textLabel.text = "30~60分間、お米を水に浸して吸水させます。\n\nタイマーが終了すれば自動的に次の「③加熱して炊く」に進みます。"
    }
    
    @IBAction func skipButton(_ sender: Any) {
        timer.timerStop()
        performSegue(withIdentifier: "goNext", sender: nil)
    }
  
}
