//
//  UYUploadImageTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/19.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

/// 上传图片的Cell,可以上传多张，也可以只上传一张
class UYUploadImageTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let uploadButton = UIButton()
    let tipsLabel = UILabel()
    var indexPath:IndexPath?
    
    var isMultipleUpload = false
    weak var delegate:UYInputTableViewCellDelegate?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        contentView.addSubview(titleLabel)
        contentView.addSubview(uploadButton)
        contentView.addSubview(tipsLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(10)
            make.width.equalTo(70)
        }
        let width = (kScreenWidth - 90 - 16 - 20)/3

        uploadButton.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(90)
            make.width.height.equalTo(width)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.blackText
        
        uploadButton.setImage(#imageLiteral(resourceName: "cell_upload_icon"), for: UIControlState.normal)
        uploadButton.tag = 0
        
        uploadButton.addTarget(self, action: #selector(uploadButtonAction(btn:)), for: UIControlEvents.touchUpInside)

        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-10)
        }
        tipsLabel.textColor = UIColor.redText
        tipsLabel.numberOfLines = 0
        tipsLabel.font = UIFont.systemFont(ofSize: 13);
        
    }
    var name:String = ""
    
    var images:[String:String]? {
        didSet {
            for subView in contentView.subviews {
                if subView.isKind(of: UIButton.classForCoder()) {
                    subView.removeFromSuperview()
                }
            }
            let count = images?.count ?? 0
            
            var orX:CGFloat = 90
            var orY:CGFloat = 10
            //90 是距离左边的距离，16是距离右边的距离，20是两个间距的宽度 3是指一行放3个
            let width = (kScreenWidth - 90 - 16 - 20)/3
            
            for index in 0...(count-1) {
                if index % 3 == 0 {
                    orX = 90
                }
                if index % 3 == 1 {
                    orX = 90 + width + 10
                }
                if index % 3 == 2 {
                    orX = 90 + (width + 10)*2
                }
                if index/3 == 0 {
                    orY = 10
                }else if index/3 == 1{
                    orY = 10 + width + 10
                }else if index/3 == 2 {
                    orY = 10 + (width + 10)*2

                }
                
                let uploadBtn = UIButton()
                
                uploadBtn.frame = CGRect(x: orX, y: orY, width: width, height: width)
                let picName = "\(name)_\(index)"
                let urlStr = images![picName]
                if let url = URL(string: urlStr!) {
                    uploadBtn.kf.setImage(with: url, for: .normal, placeholder: #imageLiteral(resourceName: "cell_upload_icon"), options: nil, progressBlock: nil, completionHandler: nil)
                }else{
                    uploadBtn.setImage(#imageLiteral(resourceName: "cell_upload_icon"), for: UIControlState.normal)
                }
                
                uploadBtn.tag = index
                uploadBtn.addTarget(self, action: #selector(uploadButtonAction(btn:)), for: UIControlEvents.touchUpInside)
                contentView.addSubview(uploadBtn)                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func getHeight(count:NSInteger) -> CGFloat {
        let width = (kScreenWidth - 90 - 16 - 20)/3
        
        if count < 4 {
            return width + 30 + 30
        }
        if (count > 3 && count < 7) {
            return width*2 + 10 + 30 + 30
        }
        return width*3 + 20 + 30 + 30
    }
    @objc func uploadButtonAction(btn:UIButton)  {
        if delegate != nil {
            delegate?.uploadImageAction!(indexPath: indexPath!, index: btn.tag)
        }
    }
}

