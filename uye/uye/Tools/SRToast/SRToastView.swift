//
//  SRToastView.swift
//  ToastDemo
//
//  Created by Tintin on 2017/11/2.
//  Copyright © 2017年 Tintin. All rights reserved.
//

import UIKit
// MARK: - 文本提示框
/// 文本提示框的View
class SRTextToast: UIView {
    
    init(msg: String) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        let tipsLabel = UILabel()
        addSubview(tipsLabel)
        tipsLabel.numberOfLines = 0
        tipsLabel.textColor = UIColor.white
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.textAlignment = .center
        tipsLabel.text = msg
        let size = tipsLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width-32-40, height: CGFloat.greatestFiniteMagnitude))
        tipsLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        frame = CGRect(x: 0, y: 0, width: size.width + 40, height: size.height+30)
        tipsLabel.center = center
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 等待提示框
/// 加载中的提示View
class SRWaitToast: UIView {
    
    override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        super.init(frame: frame)
        let width = frame.width
        let cyclyView = SRCycleView(radius: 18, lineWidth: 4)
        addSubview(cyclyView)
        cyclyView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor(red: 51.0/255, green: 51.0/255, blue: 51.0/255, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.text = "努力加载中..."
        addSubview(titleLabel)
        
        let currentHeight = cyclyView.frame.origin.y + cyclyView.frame.size.height
        titleLabel.frame = CGRect(x: 0, y: currentHeight, width: width, height: 25)
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "uye_icon"))
        addSubview(imageView)
        imageView.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// 圆形旋转View
class SRCycleView: UIView {
    
    fileprivate var cycleLayer:CAShapeLayer!
    //UIColor(red: 127.0/255, green: 217.0/255, blue: 200.0/255.0, alpha: 1).cgColor,
    init(radius:CGFloat = 30,lineWidth:CGFloat = 10,colors:[CGColor] = [UIColor(red:0.0/255.0, green:180.0/255.0, blue:150.0/255.0, alpha:1).cgColor,UIColor(red: 127.0/255, green: 217.0/255, blue: 200.0/255.0, alpha: 1).cgColor,UIColor(red: 85.0/255, green: 205.0/255, blue: 175.0/255.0, alpha: 1).cgColor,UIColor.white.cgColor]) {
        super.init(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.frame = self.bounds
        
        self.layer.addSublayer(shapeLayer)
        
        //创建梯形layer
        
        let topLayer = CAGradientLayer()
        
        topLayer.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius)
        
        topLayer.colors = [colors[2],colors[0]]
        
        topLayer.startPoint = CGPoint(x: 0, y: 0.5)
        
        topLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        shapeLayer.addSublayer(topLayer)
        
        let bottomLayer = CAGradientLayer()
        
        bottomLayer.frame = CGRect(x: 0, y: radius, width: radius*2, height: radius)
        
        bottomLayer.colors = [colors[2],colors[3],colors[3]]
        bottomLayer.locations = [0.2,0.8]
        bottomLayer.startPoint = CGPoint(x: 0, y: 0.5)
        
        bottomLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        shapeLayer.addSublayer(bottomLayer)
        
        //创建一个圆形layer
        
        cycleLayer = CAShapeLayer()
        
        cycleLayer.frame = self.bounds
        
        cycleLayer.path = UIBezierPath(arcCenter:CGPoint(x: radius, y: radius), radius:(radius-lineWidth), startAngle:CGFloat(Double.pi/Double(lineWidth)), endAngle:2*CGFloat(Double.pi) - CGFloat(Double.pi/Double(lineWidth)), clockwise:true).cgPath
        
        cycleLayer.lineWidth = lineWidth
        
        cycleLayer.lineCap = kCALineCapRound
        
        cycleLayer.lineJoin = kCALineJoinRound
        
        cycleLayer.strokeColor = UIColor.black.cgColor
        
        cycleLayer.fillColor = UIColor.clear.cgColor
        
        //根据laery1的layer形状在shaperLayer中截取出来一个layer
        shapeLayer.mask = cycleLayer
        startLoading()
        
    }
    func startLoading() {
        
        let animation = CABasicAnimation(keyPath:"transform.rotation.z")
        
        animation.toValue = 2 * Double.pi
        
        animation.duration = 1.25
        
        animation.repeatCount = HUGE
        
        self.layer.add(animation, forKey:"")
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
fileprivate let progressHeight :CGFloat = 8

class SRProgressView: UIView {
    
    var value:CGFloat = 0 {
        didSet {
           self.setNeedsDisplay()
        }
    }
    
    var themeColor = UIColor.themeColor
    
    fileprivate let progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        isOpaque = false
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //线宽度
        let lineWidth: CGFloat = 5.0
        //半径
        let radius = rect.width / 2.0 - lineWidth > 50 ? 50 : rect.width / 2.0 - lineWidth
        //中心点x
        let centerX = rect.midX
        //中心点y
        let centerY = rect.midY
        //弧度起点
        let startAngle = CGFloat(-90 * Double.pi / 180)
        //弧度终点
        
        let endAngle = CGFloat((value/100 * 360.0 - 90.0) ) * CGFloat(Double.pi) / 180.0
        
        //创建一个画布
        let context = UIGraphicsGetCurrentContext()
        
        //画笔颜色
        context!.setStrokeColor(themeColor.cgColor)
        
        //画笔宽度
        context!.setLineWidth(lineWidth)
        
        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
        context?.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        //绘制路径
        context!.strokePath()
        
        //画笔颜色
        context!.setStrokeColor(UIColor.white.cgColor)
        
        //（1）画布 （2）中心点x（3）中心点y（4）圆弧起点（5）圆弧结束点（6） 0顺时针 1逆时针
        context?.addArc(center: CGPoint(x:centerX,y:centerY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制路径
        context!.strokePath()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/*
// MARK: - 进度提示框
class SRProgressView: UIView {
    var progress:Progress! {
        didSet {
            let width = UIScreen.main.bounds.width-10
            let percentInt = progress.fractionCompleted
            
            let percent = CGFloat(percentInt)
            let expectWidth = width * percent
            
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: expectWidth, height: progressHeight))
            progressLayer.path = path.cgPath

        }
    }
    var themeColor = UIColor.themeColor {
        didSet {
            layer.borderColor = themeColor.cgColor
            progressLayer.fillColor = themeColor.cgColor
        }
    }
    
    fileprivate let progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        let screenSize =  UIScreen.main.bounds
        let frame = CGRect(x: 0, y: 0, width: screenSize.width-10, height: progressHeight)
        super.init(frame: frame)
        
        layer.cornerRadius = progressHeight/2
        layer.borderWidth = 1
        layer.borderColor = themeColor.cgColor
        layer.masksToBounds = true
        backgroundColor = UIColor.white
        
        progressLayer.fillColor = themeColor.cgColor
        layer.addSublayer(progressLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
*/

