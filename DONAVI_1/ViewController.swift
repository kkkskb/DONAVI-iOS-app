//
//  ViewController.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/10/05.
//

import UIKit



class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
  

//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        loadData()
    }
    
    //    ホームに戻るボタンでホーム画面に戻る
        @IBAction func unwindSegue(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {}
    
//MARK: - TableView関連
    @IBOutlet weak var homeTableView: UITableView!

    var menues:[MenuClass] = []
    var selectedImage: UIImage?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath as IndexPath)

        // 画像配列の番号で指定された要素の名前の画像をUIImageとする
        let img = UIImage(named: menues[indexPath.row].imageName )
                
        // Tag番号 1 で UIImageView インスタンスの生成
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = img
        
        // Tag番号 ２ で UILabel インスタンスの生成
        let label1 = cell.viewWithTag(2) as! UILabel
        label1.text = "No." + String(indexPath.row + 1)
        
        // Tag番号 ３ で UILabel インスタンスの生成
        let label2 = cell.viewWithTag(3) as! UILabel
        label2.text = String(describing: menues[indexPath.row].name)
        
        return cell
    }
    
    // Cell が選択された場合
    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = UIImage(named: menues[indexPath.row].imageName )
        if selectedImage != nil {
            // 次のViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "goNext",sender: nil)
        }
    }
    
    // Cell の高さを１２０にする
    func tableView(_ table: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    // Segue 準備、prepareで遷移前に実行される
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "goNext") {
            if let indexPath = homeTableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? MenuDetailViewController else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                destination.menuNum = indexPath.row
                destination.menuImg = selectedImage
            }
        }
    }
    
    func loadData(){
        menues.append(MenuClass(name: "白ごはん", time: "30分", imageName: "hakumai"))
        menues.append(MenuClass(name: "さつまいもごはん", time: "40分", imageName: "imo"))
    }
    
}

