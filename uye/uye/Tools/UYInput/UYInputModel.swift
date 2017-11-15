//
//  UYInputModel.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

struct UYInputModel {
    //标题
    var title:String
    //内容
    var content:String
    
    //提示语
    var placeholder:String
    //textView是否可以编辑
    var textFieldEnable:Bool = true
    
    var textFieldTextColor = UIColor.blackText
    
    
    //键盘类型
    var keyboardType:UIKeyboardType = UIKeyboardType.default
    //附带传值，默认是nil
    var subContent:String
    
    var image1:String = ""
    
    var image2:String = ""
    var images:[String:String]?
    
    
    
    init(title aTitle:String = "",content acontent:String = "",placeholder aPlaceholder:String = "",textFieldEnable aTextFieldEnable:Bool = true ,keyboardType akeyboardType:UIKeyboardType = UIKeyboardType.default,subContent aSubContent:String = "") {
        
        title = aTitle
        content = acontent
        placeholder = aPlaceholder
        textFieldEnable = aTextFieldEnable
        keyboardType = akeyboardType
        subContent = aSubContent
    }
    
    
    
}

