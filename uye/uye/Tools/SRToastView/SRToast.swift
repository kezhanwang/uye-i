//
//  SRToastView.swift
//  uye
//
//  Created by Tintin on 2017/9/29.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
extension UIResponder {
    
    /// 展示文本提示,不会自动消失
    func showTextToast(msg:String)  {
        let toast = SRToast.shared
        toast.msg = msg
        toast.isShowActivity = false
        toast.showToastView()
    }
    /// 展示文本提示以及自动消失，默认时间1.5s
    func showTextToastAutoDismiss(msg:String,second:DispatchTime = 1.5)  {
        let toast = SRToast.shared
        toast.msg = msg
        toast.isShowActivity = false
        toast.showToastAutoDismiss(second: second)
    }
    
    /// 展示风火轮+文字
    func showWaitToast(msg:String = "")  {
        let toast = SRToast.shared
        toast.msg = msg
        toast.isShowActivity = true
        toast.showToastView()
    }
    /// 展示风火轮+文字，自动消失
    func showWaitToastAutoDismiss(msg:String = "",second:DispatchTime = 1.5) {
        let toast = SRToast.shared
        toast.msg = msg
        toast.isShowActivity = true;
        toast.showToastAutoDismiss(second: second)
    }
    
    /// 展示进度条+文字
    func showProgressToast(msg:String = "",progress:Progress) {
        let toast = SRToast.shared
        toast.msg = msg;
        toast.progress = Double(progress.completedUnitCount/progress.totalUnitCount)
        toast.showToastView()
    }
    
    func dismissToast() {
        SRToast.shared.dismissToastOnMain()
    }
    
}
class SRToast: UIView {
   
    //设置提示的内容，默认为空
    var msg :String = ""{
        didSet {
            msgLabel.text = msg
//            setupSubViews()
        }
    }
    //设置进度条，默认是0.0，不展示
    var progress : Double = 0.0 {
        didSet {
            progressView.progress = progress
//            setupSubViews()
        }
    }
    //设置进度条或者风火轮是否展示，默认是展示
    var isShowActivity :Bool = true {
        didSet {
//            setupSubViews()
        }
    }
    
    fileprivate let blackBgView : UIView = UIView()
    fileprivate let msgLabel : UILabel = UILabel()
    fileprivate let progressView : SRCycleProgressView = SRCycleProgressView()
    
    static let shared = SRToast()

    override init(frame: CGRect) {
        super.init(frame: frame)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.top.left.bottom.right.equalTo(0)
        })
        
        addSubview(blackBgView)
        blackBgView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        blackBgView.layer.cornerRadius = 8
        blackBgView.layer.masksToBounds = true
        blackBgView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.greaterThanOrEqualTo(20)
            make.right.lessThanOrEqualTo(-20)
        }
        
        blackBgView.addSubview(progressView)
        blackBgView.addSubview(msgLabel)
        
        progressView.backgroundColor = UIColor.clear
        msgLabel.textColor = UIColor.white
        msgLabel.numberOfLines = 0;
        msgLabel.textAlignment = NSTextAlignment.center;
        msgLabel.font = UIFont.systemFont(ofSize: 15)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSubViews() {
        if msgLabel.text?.isEmpty == true {
            msgLabel.removeFromSuperview()
        }
        if msgLabel.superview == nil {
            blackBgView.addSubview(msgLabel)
        }
        if isShowActivity {
            if progressView.superview == nil {
                blackBgView.addSubview(progressView)
            }
        }else{
            progressView.removeFromSuperview()
        }
        if isShowActivity {
            if msgLabel.text?.isEmpty == false { //既有文字，也有风火轮
                progressView.snp.remakeConstraints({ (make) in
                    make.top.equalTo(10)
                    make.centerX.equalTo(blackBgView)
                    make.width.height.equalTo(50)
                })
                msgLabel.snp.remakeConstraints({ (make) in
                    make.top.equalTo(progressView.snp.bottom).offset(10)
                    make.left.equalTo(20)
                    make.right.equalTo(-20)
                    make.bottom.equalTo(-15)
                    make.width.greaterThanOrEqualTo(100)
                })
            }else{//只有风火轮
                progressView.snp.remakeConstraints({ (make) in
                    make.top.left.equalTo(20)
                    make.bottom.right.equalTo((-20))
                    make.width.height.equalTo(50)
                })
            }
        }else{//只有文字
            msgLabel.snp.remakeConstraints({ (make) in
                make.top.left.equalTo(20)
                make.bottom.right.equalTo((-20))
            })
        }
        
        blackBgView.snp.remakeConstraints { (make) in
            make.center.equalTo(self)
            make.left.greaterThanOrEqualTo(20)
            make.right.lessThanOrEqualTo(-20)
        }
        
    }

}

// MARK: - 生命周期
extension SRToast {
    open func showToastView() {
        setupSubViews()
        layoutIfNeeded()
        
        guard self.isHidden else {
            return
        }
        
        self.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
    }
    open func showToastAutoDismiss(second:DispatchTime = 1.5) {
        showToastView()
        DispatchQueue.main.asyncAfter(deadline: second) {
            self.dismissToastOnMain(mainThread: false)
        }
    }

    fileprivate func dismissToastOnMain(mainThread:Bool = true) {
        if mainThread {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0.0;
                }, completion: { (isFinish) in
                    if isFinish {
                        self.isHidden = true
                    }
                })
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0;
            }, completion: { (isFinish) in
                if isFinish {
                    self.isHidden = true
                }
            })
        }
    }
    
}


extension DispatchTime :ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
extension DispatchTime :ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
