//
//  Menu.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/12/09.
//

import Foundation

class MenuClass  {
    private(set) public var name : String //料理名
    private(set) public var time : String //所要時間
    private(set) public var imageName : String //画像の名前.jpeg
    
    init(name: String, time: String, imageName: String) {
        self.name = name
        self.time = time
        self.imageName = imageName
    }
}
