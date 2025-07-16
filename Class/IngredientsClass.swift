//
//  Ingredients.swift
//  DONAVI_1
//
//  Created by 板谷研 on 2021/12/13.
//

import Foundation

class IngredientsClass {
    private(set) public var name : String = ""
    private(set) public var comment : String = ""
    
    init(name:String,comment:String) {
        self.name = name
        self.comment = comment
    }
}
