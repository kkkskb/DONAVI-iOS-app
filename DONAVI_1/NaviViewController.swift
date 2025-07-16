//
//  NaviViewController.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/10/05.
//

import UIKit
import AVFoundation
import CoreBluetooth


class NaviViewController: UIViewController {
    
    //説明文書くラベル
    @IBOutlet weak var procLabel: UILabel!
    @IBOutlet weak var timerCountLabel: UILabel!
    @IBOutlet weak var frecLabel: UILabel!
//    let uiview = NaviViewController()
    //取得した周波数の値をintで格納
    var frec : Int = 0
    var frecCount : Int = 0
    var timer:TimerClass!
    var remainCount:Int = 80
    
//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //BLE通信をsetup
        BLEsetup()
        
        procLabel.text = "中強火で点火\n↓\nスタートボタンを押す"
        // UILabelの文字列から、attributedStringを作成する
        let attrText = NSMutableAttributedString(string: procLabel.text!)
        
        // rangeで該当箇所を指定する（ここでは「スタートボタン」が対象）.
        attrText.addAttribute(.foregroundColor,
                              value: UIColor.orange, range: NSMakeRange(9, 7))
        
        
        
        // attributedTextとしてUILabelに追加する
       procLabel.attributedText = attrText
        
    }
    
    
    //スタートボタンを押した時
    @IBAction func StartButton(_ sender: Any) {
        timerCountLabel.text = "鍋からピー音が鳴るまで待つ"

        timer = TimerClass(label: timerCountLabel, uiview: self)
        timer.timerSetup(countTime: remainCount)
//        デバック用　ボタンでスタートする
//        timer.timerStart()
    }
    
    
    //ストップボタンを押したとき
    @IBAction func StopButton(_ sender: Any) {
        timer.timerStop()
        remainCount = timer.timerValue - timer.countTimer
    }
    
    //ViewのUIパーツの初期設定
    func setUi(){
        // UILabelの文字列から、attributedStringを作成する
        let attrText = NSMutableAttributedString(string: procLabel.text!)
        
        // rangeで該当箇所を指定する（ここでは「スタートボタン」が対象）.
        attrText.addAttribute(.foregroundColor,
                              value: UIColor.orange, range: NSMakeRange(8, 7))
//
//        attrText2.addAttributes([
//                .foregroundColor: UIColor.blue,
//                .font: UIFont.boldSystemFont(ofSize: 24)
//            ], range: NSMakeRange(3, 3))
        
        // attributedTextとしてUILabelに追加する
        procLabel.attributedText = attrText
    }


    
    
    //MARK: - ESP32とのBLE通信設定
    //BLE通信可能にするためにinfo.plistでダイアログを出すように設定
    let kUARTServiceUUID = "787a87b9-7a3b-4906-9478-937424856af9" // サービス側 （ペリフェラル）
    let kRXCharacteristicUUID = "a9c00e86-e3ec-44a0-89b8-2b9a70ba5c7c" // クライアント側　（セントラル）
    
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var serviceUUID : CBUUID!
    var kRXCBCharacteristic: CBCharacteristic?
    var charcteristicUUIDs: [CBUUID]!
    
    private func BLEsetup() {
        print("setup...")
        
        centralManager = CBCentralManager()
        centralManager.delegate = self as CBCentralManagerDelegate
        
        serviceUUID = CBUUID(string: kUARTServiceUUID)
        charcteristicUUIDs = [CBUUID(string: kRXCharacteristicUUID)]
    }
}
    
  


//MARK: - BLE通信用extension
//MARK: - CBCentralManagerDelegate
extension NaviViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")
        
        switch central.state {
        
        //電源ONを待って、スキャンする
        case CBManagerState.poweredOn:
            let services: [CBUUID] = [serviceUUID]
            centralManager?.scanForPeripherals(withServices: services,
                                               options: nil)
        default:
            break
        }
    }
    
    /// ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        self.peripheral = peripheral
        centralManager?.stopScan()
        
        //接続開始
        central.connect(peripheral, options: nil)
        print("  - centralManager didDiscover")
    }
    
    /// 接続されると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
        print("  - centralManager didConnect")
    }
    
    /// 切断されると呼ばれる？
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#function)
        if error != nil {
            print(error.debugDescription)
            BLEsetup() // ペアリングのリトライ
            return
        }
    }
}

//MARK: - BLE通信　CBPeripheralDelegate
extension NaviViewController: CBPeripheralDelegate {
    
    /// サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        //キャリアクタリスティク探索開始
        if let service = peripheral.services?.first {
            print("Searching characteristic...")
            peripheral.discoverCharacteristics(charcteristicUUIDs,
                                               for: service)
        }
    }
    
    /// キャリアクタリスティク発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        print("service.characteristics.count: \(service.characteristics!.count)")
        for characteristics in service.characteristics! {
            if(characteristics.uuid == CBUUID(string: kRXCharacteristicUUID)) {
                self.kRXCBCharacteristic = characteristics
                print("kTXCBCharacteristic did discovered!")
            }
        }
        
        if(self.kRXCBCharacteristic != nil) {
            startReciving()
        }
        print("  - Characteristic didDiscovered")
        
    }
    
    private func startReciving() {
        guard let kRXCBCharacteristic = kRXCBCharacteristic else {
            return
        }
        peripheral.setNotifyValue(true, for: kRXCBCharacteristic)
        print("Start monitoring the message from Arduino.\n\n")
    }
    
    
    /// データ送信時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        if error != nil {
            print(error.debugDescription)
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print(#function)
    }
    
    // データ更新時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //        print(#function)
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        updateWithData(data: characteristic.value!)
    }
    

    
    // データをアップデートして、ラベルに表示
    private func updateWithData(data : Data) {
        print(data)
        if let dataString = String(data: data, encoding: String.Encoding.utf8) {
            frec = Int(dataString)!
            print(frec)
            //テキストラベルを編集して画面に表示
            frecLabel.text = dataString
            if 3200 < frec && frec < 4800 {
                frecCount += 1
            }
            if frecCount > 50 && frecCount < 60 {
                let timer = TimerClass(label: timerCountLabel, uiview: self)
                timer.timerSetup(countTime: 80)
                timer.timerStart()
                frecCount = 100
            }

            
        }
    }
}

