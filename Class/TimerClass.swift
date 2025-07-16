//
//  TimerCount.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2022/01/07.
//

import Foundation
import AVFoundation
import UIKit

class TimerClass {

    //タイマーの変数を作成
    var timer : Timer?
    //カウント（経過時間）の変数を作成
    var countTimer = 0
    //設定値を扱うキーを設定
    let settingKey = "timer_value"
    //設定する時間
    var timerValue:Int = 0
    
    var timerCountLabel : UILabel?
    var uiviewClass : UIViewController?
    
    //ラベルとViweのinitilizer
    init(label:UILabel , uiview:UIViewController){
        timerCountLabel = label
        uiviewClass = uiview
    }
    
    func timerSetup(countTime time:Int) {
        timerValue = time
//        //UserDefaultsのインスタンスを作成
//        let settings = UserDefaults.standard
//        //UserDefaultsに初期値を登録
//        settings.register(defaults: [settingKey:time])
    }
    
    func timerStart() {
        //タイマーカウントダウンの処理
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが、実行中だったらスタートしない
            if nowTimer.isValid == true {
                //何も処理しない
                return
            }
        }
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(self.timerInterrupt(_:)),userInfo: nil,repeats: true)
    }
    
    func timerStop(){
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true{
                //タイマーを停止
                nowTimer.invalidate()
            }
        }
    }
    
    
    //画面の更新をする(戻り値：remainCount:残り時間)
    func displayUpdate() -> Int {
        //残り時間（remainCount）を生成
        let remainCount = timerValue - countTimer
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.allowedUnits = [.minute, .second]
        
        let timeCount:TimeInterval = TimeInterval(remainCount)
        
        //remainCountをラベルに表示
        timerCountLabel?.text = dateFormatter.string(from: timeCount)!
        //残り時間を戻り値に設定
        return remainCount
    }
    
    //経過時間の処理
    @objc func timerInterrupt(_ timer:Timer ){
        //count（経過時間）に＋１していく
        countTimer += 1
//        print(displayUpdate())
        //remainCount(残り時間)が０以下の時の処理
        if displayUpdate() <= 0 {
            //初期化処理
            countTimer = 0
            //タイマー停止
            timer.invalidate()
            //アラーム音鳴らす
            soundPlayer(player: &backmusicPlayer, path: backmusicPath, count: -1)
            //ダイアログを作成
            let alertController = UIAlertController(title: "タイマー終了時間です。", message: "次の手順へ進みます。", preferredStyle: .alert)
            //ダイアログに表示させるOKボタンを作成
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
                //OKボタンが押されたときの処理をクロージャで実装
                (action: UIAlertAction!) -> Void in
                //実際の処理
                self.backmusicPlayer.stop()
                //画面遷移
                self.uiviewClass?.performSegue(withIdentifier: "goNext", sender: nil)
            })
            //アクションを追加
            alertController.addAction(defaultAction)
            //ダイアログの表示
            self.uiviewClass?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //ーーーーーアラーム音関係ーーーーーーーーーーーー
    //バックミュージックの音源ファイルの指定
    let backmusicPath = Bundle.main.bundleURL.appendingPathComponent("アラーム-01.mp3")
    
    //バックミュージック用のプレイヤーインスタンスを作成
    var backmusicPlayer = AVAudioPlayer()
    
    //リファクタリングする　コードを見やすく
    fileprivate func soundPlayer(player:inout AVAudioPlayer, path:URL, count:Int){
        do{
            player = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
            player.numberOfLoops = count
            player.play()
        }catch{
            print("エラーが発生しました！")
        }
    }
    
}
