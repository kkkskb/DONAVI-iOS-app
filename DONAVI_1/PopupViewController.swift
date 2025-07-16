//
//  PopupViewController.swift
//  DONAVI_1
//
//  Created by Kusakabe Koki on 2022/03/05.
//

import UIKit

class PopupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //値受け渡し用
    var procData:[String] = []
    
//    @IBAction func backButton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//
//    }

    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "goNext2", sender: nil)
    }
    
    //遷移時にprocDataを渡すprepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? KyusuiViewController
//        let _ = nextVC?.view //ハックコードとやら
        nextVC?.procData = procData
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
