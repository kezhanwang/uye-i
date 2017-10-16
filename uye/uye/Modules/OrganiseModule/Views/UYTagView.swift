//
//  UYTagView.swift
//  uye
//
//  Created by Tintin on 2017/10/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYTagView: UIView {
    var estimatedHeight:CGFloat = 0
    
    fileprivate lazy var deleteBtn : UIButton = {
        () -> UIButton in
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(#imageLiteral(resourceName: "search_delete_icon"), for: UIControlState.normal)
        btn.tag = 100
        btn.addTarget(self, action: #selector(deleteHistory), for: UIControlEvents.touchUpInside)
        return btn
    }()

    var tagsArray : [String] = [] {
        didSet{
            addSubTags()
        }
    }
    
    init(title:String,showDelete:Bool = false) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        addHeadView(title: title, showDelete: showDelete)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func deleteHistory() {
        
    }
}
extension UYTagView {
    func addHeadView(title:String,showDelete:Bool)  {
        let titleLabel :UILabel = UILabel()
        titleLabel.textColor = UIColor.darkGrayText
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.tag = 99
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(16)
        }
        if showDelete {
            addSubview(deleteBtn)
            deleteBtn.snp.makeConstraints({ (make) in
                make.top.equalTo(10)
                make.right.equalTo(-16)
            })
        }
    }
    func addSubTags() {
        for view in self.subviews {
            if view.tag < 90 {
                view.removeFromSuperview()
            }
        }
        let count = tagsArray.count
        
        guard count > 0 else {
            return
        }
        
        var orY :CGFloat = 40 //默认初始高度
        var orX :CGFloat = 16 //初始开始X点
        let space :CGFloat = 12
        
        let oneHeight :CGFloat = 30 //设置一行为30高
        let totleWith :CGFloat = kScreenWidth - 2*orX
        
        for index in 0...count {
            let tag = UYTag(title: tagsArray[index], origin: CGPoint(x: orX, y: orY))
            tag.tag = index
            addSubview(tag)
            guard index < count-1 else {
                orY = orY + oneHeight + space
                estimatedHeight = orY
                break
            }
            orX = orX + tag.frame.size.width
            let expectNextWidth = getTextRectSize(text: tagsArray[index+1] as NSString).size.width + 20
            let minWidth = expectNextWidth < 80 ? 80 : expectNextWidth
            if orX + minWidth > totleWith {
                orY = orY + oneHeight + space
                orX = 16
            }else{
                orX = orX + space 
            }
        }
    }
}
class UYTag: UIView {
    
    var title:String?
    fileprivate lazy var titleLabel : UILabel = {
        () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.blackText
        return lable
    }()
   
    init(title:String,origin:CGPoint) {
        let size : CGSize = getTextRectSize(text: title as NSString).size
        let minWidth = size.width + 20 < 80 ? 80 : size.width + 20
        super.init(frame: CGRect(origin: origin, size: CGSize(width: minWidth, height: 30)))
        addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        backgroundColor = UIColor.lightBackground
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
func getTextRectSize(text:NSString,font:UIFont = UIFont.systemFont(ofSize: 14)) -> CGRect {
    let attributes = [NSAttributedStringKey.font: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    
    let rect:CGRect = text.boundingRect(with: CGSize(width: 999, height: 30), options: option, attributes: attributes, context: nil)
    return rect;
}
protocol UYTagViewDelegate {
    
}
