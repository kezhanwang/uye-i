//
//  UYTagView.swift
//  uye
//
//  Created by Tintin on 2017/10/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYTagView: UIView {
    var estimatedHeight:CGFloat = 50
    weak var delegate : UYTagViewDelegate?
    
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
        if delegate != nil {
            delegate?.deleteHistory()
        }
    }
}
extension UYTagView {
    func addHeadView(title:String,showDelete:Bool)  {
        let titleLabel :UILabel = UILabel()
        titleLabel.textColor = UIColor.grayText
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
            tag.delegate = self
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
        if self.delegate != nil  {
            self.delegate?.tagViewEstimatedHeight(tagView: self, height: estimatedHeight)
        }
    }
}
extension UYTagView : UYTagDelegate {
    func tagAcion(tag: UYTag) {
        if delegate != nil {
            delegate?.tagAcion(title: tag.title ?? "" )
        }
    }
}

class UYTag: UIView {
    
    
    var title:String?
    
    weak var delegate : UYTagDelegate?
    
    fileprivate lazy var titleLabel : UILabel = {
        () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.blackText
        return lable
    }()
   
  
    
    init(title atitle:String,origin:CGPoint) {
        let size : CGSize = getTextRectSize(text: atitle as NSString).size
        let minWidth = size.width + 20 < 80 ? 80 : size.width + 20
        super.init(frame: CGRect(origin: origin, size: CGSize(width: minWidth, height: 30)))
        addSubview(titleLabel)
        title = atitle
        titleLabel.text = title
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        backgroundColor = UIColor.lightBackground
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tagClick))
        addGestureRecognizer(tapGes)
    }
    @objc func tagClick() {
        if delegate != nil {
            delegate?.tagAcion(tag: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class UYAreaTag : UIView {
    var title:String?

    fileprivate lazy var deleteBtn : UIButton = {
        () -> UIButton in
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "user_delete_icon"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(deleteAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    weak var delegate:UYAreaTagDelegate?
    init(title atitle:String,origin:CGPoint) {
        title = atitle
        let aTag = UYTag(title: atitle, origin: CGPoint(x: 0, y: 0))
        let width = aTag.bounds.width + 10
        let height = aTag.bounds.height
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: height))
        addSubview(aTag)
        addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints({ (make) in
            make.top.equalTo(-4)
            make.right.equalTo(-5)
        })
        backgroundColor = UIColor.white
        aTag.delegate = self
        
        
    }
    @objc func deleteAction() {
        print("删除按钮")
        if self.delegate != nil {
            self.delegate?.deleteAreaTag(area: self)
        }
//        if delegate != nil {
//            delegate?.deleteTag!(tag: self)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UYAreaTag :UYTagDelegate {
    func tagAcion(tag: UYTag) {
        deleteAction()
    }
}
func getTextRectSize(text:NSString,font:UIFont = UIFont.systemFont(ofSize: 14)) -> CGRect {
    let attributes = [NSAttributedStringKey.font: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    
    let rect:CGRect = text.boundingRect(with: CGSize(width: 999, height: 30), options: option, attributes: attributes, context: nil)
    return rect;
}
 protocol UYTagDelegate : NSObjectProtocol {
    func tagAcion(tag:UYTag)
//    @objc optional func deleteTag(tag:UYTag)
//    @objc optional func loginTypeChange(ispwdLogin:Bool)
}
protocol UYTagViewDelegate : NSObjectProtocol {
    func tagAcion(title:String)
    func deleteHistory()
    func tagViewEstimatedHeight(tagView:UYTagView,height:CGFloat)
}
protocol UYAreaTagDelegate:NSObjectProtocol {
    func deleteAreaTag(area:UYAreaTag)
}
