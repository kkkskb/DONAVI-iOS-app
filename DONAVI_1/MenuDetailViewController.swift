//
//  MenuDetailViewController.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/12/09.
//

import UIKit

class MenuDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    var menuNum: Int!  //前画面のtableviewの配列番号を格納
    var menuImg: UIImage!  //同じく画像
    
    var ingrData:[IngredientsClass] = []
    let procData = ["①洗米する","↓（スタートボタンを押してナビ開始）","②３０分間浸水","↓（タイマー終了のアラーム音）","③加熱して炊く","↓（土鍋からピー音が鳴るとタイマー開始）","④１５分間蒸らす","⑤完成"]
    let sectTitles = ["材料・分量","手順"]

    @IBOutlet weak var cookTableView: UITableView!
    @IBOutlet weak var cookStartButton: UIButton!
    @IBOutlet weak var menuImage: UIImageView!
    
//    MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        print(menuNum!)
        self.cookTableView.delegate = self
        self.cookTableView.dataSource = self
        loadData()
        cookStartButton.setTitle("「"+String(procData[2])+"」をスタートする", for: .normal)
    }

    //遷移時にprocDataを渡すprepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? PopupViewController
//        let _ = nextVC?.view //ハックコードとやら
        nextVC?.procData = procData
    }
    
    
    @IBAction func cookStartButton(_ sender: Any) {
//        performSegue(withIdentifier: "goNext", sender:nil)
        performSegue(withIdentifier: "goNext2", sender:nil)
    }
    
    
//    @IBAction func popupButton(_ sender: Any) {
//        performSegue(withIdentifier: "goNext", sender:nil)
//    }
    
//    MARK: - TableView関連
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
             return ingrData.count
         }else if section == 1 {
             return procData.count
         }else{
             return 0
         }
    }
    
    //謎だったからコメントアウト
//    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
//        _ = self.procData[indexPath.row]
//        let label = cell.viewWithTag(1) as! UILabel
//        label.text = procData[indexPath.row]
//    }
    
    //CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cookCell" , for: indexPath)
        if indexPath.section == 0 {
            // Tag番号 1 で UILabel インスタンスの生成
            let label1 = cell.viewWithTag(1) as! UILabel
            label1.text = ingrData[indexPath.row].name
            // Tag番号 2 で UILabel インスタンスの生成
            let label2 = cell.viewWithTag(2) as! UILabel
            label2.text = ingrData[indexPath.row].comment
 
        }else if indexPath.section == 1{
            // Tag番号 1 で UILabel インスタンスの生成
            let label1 = cell.viewWithTag(1) as! UILabel
            label1.text = procData[indexPath.row]
            label1.numberOfLines = 4
            
            // Tag番号 2 で UILabel インスタンスの生成
            let label2 = cell.viewWithTag(2) as! UILabel
            label2.text = ""
            
            //手順説明の色とサイズ変更
            let n = indexPath.row
            if n == 1||n==3||n==5{
                label1.textColor = UIColor.systemGray
                label1.font = UIFont.systemFont(ofSize: 14)
            }
            //「スタートボタン」の文字列だけ色チェンジ
            if n==1 {
                // UILabelの文字列から、attributedStringを作成する
                let attrText = NSMutableAttributedString(string: label1.text!)
                
                // rangeで該当箇所を指定する（ここでは「スタートボタン」が対象）.
                attrText.addAttribute(.foregroundColor,
                                      value: UIColor.orange, range: NSMakeRange(2, 7))
                
                // attributedTextとしてUILabelに追加する
                label1.attributedText = attrText
            }
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    //材料tableのデータを詰める
    func loadData()  {
        ingrData.append(IngredientsClass(name: "白米", comment: "1合"))
        ingrData.append(IngredientsClass(name: "水", comment: "200ml"))
        
        menuImage.image = menuImg
        
    }
 

}
