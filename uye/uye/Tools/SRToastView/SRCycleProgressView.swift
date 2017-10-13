//
//  SRCycleProgressView.swift
//  uye
//
//  Created by Tintin on 2017/9/29.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class SRCycleProgressView: UIView {
    //进度，默认0.0
    var progress : Double = 0.0 {
        didSet {
            progressLayer.opacity = 0
            setNeedsDisplay()
        }
    }
    var progressTintColor : UIColor = .white //进度条的颜色，默认是白色
    var cycleWith : CGFloat = 0.05 //进度条的宽度，默认是总宽度的二十分之一，即0.05
    
    fileprivate let activityView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let progressLayer : CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        configSubView()
    }
   fileprivate func configSubView()  {
        addSubview(activityView)
        activityView.snp.makeConstraints {(make) in
            make.center.equalTo(self)
        }
        activityView.startAnimating()
    }
    
    override func draw(_ rect: CGRect) {
        if (progress > 0 && progress < 1) {
            if (self.activityView.isAnimating) {
                self.activityView.stopAnimating()
            }
            drawCycleProgress()
        }else{
            activityView.startAnimating()
        }
    }
    
   fileprivate func drawCycleProgress()  {
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let lineWidth:CGFloat = bounds.width*cycleWith
        let radius = bounds.width/2 - lineWidth
        let start = -Double.pi/2
        let end = -Double.pi/2 + Double.pi * 2 * progress;
        
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressTintColor.cgColor
        progressLayer.opacity = 1
        progressLayer.lineCap = kCALineCapRound
        progressLayer.lineWidth = lineWidth
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
        progressLayer.path = path.cgPath
        self.layer.addSublayer(progressLayer)

    }
 

}
