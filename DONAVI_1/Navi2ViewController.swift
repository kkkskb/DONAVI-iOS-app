//
//  Navi2ViewController.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/12/07.
//

import UIKit

class Navi2ViewController: UIViewController {

 
    @IBOutlet weak var procLabel: UILabel!
    @IBOutlet weak var timerCountLabel: UILabel!
//    let uiview = Navi2ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timer = TimerClass(label: timerCountLabel, uiview: self)
        timer.timerSetup(countTime: 900)
        timer.timerStart()
        
    }

}
