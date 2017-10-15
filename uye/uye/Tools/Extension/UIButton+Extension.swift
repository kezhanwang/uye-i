//
//  UIButton+Extension.swift
//  kezhan
//
//  Created by Tintin on 2017/5/12.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title :String,btnFrame:CGRect,normalBackImage:String = "",highlightedBackImage:String = "",disableImage:String = "") {
        self.init(type: .custom)
        frame = btnFrame
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.kz_fontWithSize(size: 16)
        setBackgroundImage(UIImage(named: normalBackImage), for: .normal)
        setBackgroundImage(UIImage(named: highlightedBackImage), for: .highlighted)
        setBackgroundImage(UIImage(named: disableImage), for: .disabled)
    }
    convenience init (aFrame : CGRect, image:UIImage?,selectImage:UIImage? = nil) {
        self.init(type: .custom)
        frame = aFrame
        setImage(image, for: .normal)
        setImage(selectImage, for: .selected)
    }
    
}
extension UIButton {
    
    /// 倒计时开始(专门用于获取短信验证码)
    func beginCountDown() {
        
        // 定义需要计时的时间
        var timeCount = 60
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: { [weak self] in
            //如果对象释放了，那么直接取消
            if self == nil {
                codeTimer.cancel()
            }
            // 每秒计时一次
            timeCount = timeCount - 1
            // 时间到了取消时间源
            if timeCount <= 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
//                    self?.backgroundColor = UIColor.white
                    self?.setTitle("获取验证码", for: .normal)
                    self?.isEnabled = true
                    self?.isUserInteractionEnabled = true
                }
            }else{
                // 返回主线程处理一些事件，更新UI等等
                DispatchQueue.main.async {
//                    self?.backgroundColor = UIColor.lineGray
                    self?.isEnabled = false
                    self?.setTitle("\(timeCount)s", for: .normal)
                    self?.isUserInteractionEnabled = false
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
}
