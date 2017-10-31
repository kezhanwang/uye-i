//
//  UYAreaTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYAreaTableViewCell: UITableViewCell {
    weak var delegate:UYAreaTableViewCellDelegate?
    fileprivate let titleLabel = UILabel()
    fileprivate let addBtn = UIButton()
    fileprivate let tipsLabel = UILabel()
    
    fileprivate var nextOrY :CGFloat = 10
    fileprivate var nextOrX :CGFloat = 90
    fileprivate var leftWidth:CGFloat = kScreenWidth - 90 - 16 - 30
    fileprivate var currentRow : CGFloat = 0
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(addBtn)
        contentView.addSubview(tipsLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(16)
            
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(90)
        }
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-16)
        }
        titleLabel.textColor = UIColor.blackText
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = "就业地区"
        titleLabel.tag = 1000
        
        tipsLabel.textColor = UIColor.placeholderText
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.text = "请添加您期望的工作地区"
        
        addBtn.setImage(#imageLiteral(resourceName: "user_add_icon"), for: UIControlState.normal)
        addBtn.addTarget(self, action: #selector(addAreaTagAction), for: UIControlEvents.touchUpInside)
        addBtn.tag = 10001
    }
    var areaArray = [String]() {
        didSet {
            if areaArray.count > 0 {
                tipsLabel.isHidden = true
            }else{
                tipsLabel.isHidden = false
            }
            reloadTagViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    @objc func addAreaTagAction()  {
        if self.delegate != nil {
            self.delegate?.areaCellAddTagAction()
        }
    }
}
extension UYAreaTableViewCell {
    func reloadTagViews()  {
        for subView in contentView.subviews {
            if subView.isKind(of: UYAreaTag.self) {
                subView.removeFromSuperview()
            }
        }
        nextOrX = 90
        nextOrY = 10
        leftWidth = kScreenWidth - 90 - 16 - 30
        currentRow = 0
        for areaName in areaArray {
            addTagAction(areaName: areaName)
        }
        if self.delegate != nil {
            let tempHeight = currentRow*(30+12) + 10 + 30 + 10
            self.delegate?.areaCellHeightChanged(height: tempHeight)
        }
    }
    func addTagAction(areaName:String) {
        let size = getTextRectSize(text: areaName as NSString).size
        let minWidth = size.width + 20 < 80 ? 80 : size.width + 20
        if leftWidth > (minWidth+10) {
           leftWidth -= (minWidth+10)
        }else{
            nextOrX = 90
            currentRow += 1
            leftWidth = kScreenWidth - 90 - 16
            leftWidth -= (minWidth+10)
        }
        
        nextOrY = currentRow*(30+12)+10
        let tagView = UYAreaTag(title: areaName, origin: CGPoint(x: nextOrX, y: nextOrY))
        tagView.delegate = self
        contentView.addSubview(tagView)
        nextOrX += (minWidth + 10)
    }
}
extension UYAreaTableViewCell : UYAreaTagDelegate {
    func deleteAreaTag(area: UYAreaTag) {
        if self.delegate != nil {
            self.delegate?.areaCellDeleteTagAction(area: area.title!)
        }
    }
}
protocol UYAreaTableViewCellDelegate : NSObjectProtocol {
    func areaCellAddTagAction()
    func areaCellDeleteTagAction(area:String)
    func areaCellHeightChanged(height:CGFloat)
}
