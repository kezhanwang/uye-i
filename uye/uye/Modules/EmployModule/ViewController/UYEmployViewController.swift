//
//  UYEmployViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let orderCelIdentifier = "UYOrderCollectionViewCellIdentifier"
class UYEmployViewController: UYBaseViewController {
    
    
    @IBOutlet fileprivate weak var bottmContraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orderCollectionView: UICollectionView!
    fileprivate var orderList:[UYOrderModel] = []
    fileprivate var hasMore = false //是否还有更多，默认是没有的
    fileprivate var page:Int = 1 //从第一页开始
    fileprivate var currentIndex:Int = 0 //当前展示的
    fileprivate var totlePage :Int = 1//默认也是1
    fileprivate var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 21))
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "U业帮"
//        view.backgroundColor = UIColor.background
        NotificationCenter.default.addObserver(self, selector: #selector(noticeHasMoreOrder), name: MakeOrderSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatusChange), name: LoginStatusChange, object: nil)
        if UYAPPManager.shared.userInfo != nil {
            loadOrderList()
        }
    }
    override func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.blackText
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: titleLabel)

        
        loadCollectionView()
        showErorView()
    }
   @objc func noticeHasMoreOrder()  {
        if hasMore == false {
            hasMore = true
        }
    }
    @objc func loginStatusChange() {
        if page > 1 {
            return
        }
        if UYAPPManager.shared.userInfo == nil {
            showErorView()
        }else{
            loadOrderList(isRefash: true)
        }
    }
}



// MARK: - 有订单的列表UI 设置
extension UYEmployViewController {
    func loadCollectionView()  {
//        view.bringSubview(toFront: orderCollectionView)
        orderCollectionView.backgroundColor = UIColor.clear
        setBackgroundView()
        orderCollectionView.register(UINib(nibName: "UYOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: orderCelIdentifier)
        bottmContraint.constant = kTabBarHeight
        topConstraint.constant = kNavigationHeight
        
    }
    func setBackgroundView()  {
        let backgroundView = UIView()
        view.insertSubview(backgroundView, at: 0)
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: kNavigationHeight, width: kScreenWidth, height: kScreenHeight-kTabBarHeight-kNavigationHeight)
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor(hexColor: "C9C9C9").cgColor, UIColor(hexColor: "e3e3e3").cgColor]
        backgroundView.layer.addSublayer(gradientLayer)
        
    }
   
    func shakeCollectionView() {
        var shakeTime = UserDefaults.standard.integer(forKey: "com.uy.shake.time")
        if shakeTime < 2 {
            DispatchQueue.main.async {
                showTextToast(msg: "向左滑动查看更多订单哦")

                UIView.animate(withDuration: 0.8, animations: {
                    self.orderCollectionView.scrollRectToVisible(CGRect(x: 100, y: 0, width: kScreenWidth, height: 300), animated: false)
                }, completion: { (finish) in
                    if finish {
                        UIView.animate(withDuration: 0.8, animations: {
                            self.orderCollectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: kScreenWidth, height: 300), animated: false)
                        })
                    }
                })
            }
            shakeTime = shakeTime + 1
            UserDefaults.standard.set(shakeTime, forKey: "com.uy.shake.time")
        }
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension UYEmployViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if hasMore {
            return orderList.count + 1
        }
        return orderList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: orderCelIdentifier, for: indexPath) as! UYOrderCollectionViewCell
        cell.delegate = self
        if indexPath.row >= orderList.count {
            cell.order = nil
        }else{
            cell.order = orderList[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = kScreenHeight - kNavigationHeight - kTabBarHeight
        return CGSize(width: kScreenWidth, height: height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x/kScreenWidth)
        let indexPage:Int = currentIndex+1
        if hasMore {
            if indexPage >= page {
                loadOrderList()
            }
        }
        
        if errorView.isHidden == true {
            titleLabel.text = "\(indexPage)/\(totlePage)"
        }else{
            titleLabel.text = ""
        }
        
    }

//    collectionview
}
// MARK: - 无数据的展示
extension UYEmployViewController {
    fileprivate func showErorView()  {
        setupErrorView(image: "order_empty_icon", title: "订单空空如也！\n让U业帮为您的大好前程出把力吧！")
        errorView.isHidden = false
    }
    fileprivate func hiddenErrorView()   {
        errorView.isHidden = true
    }
}

// MARK: - 按钮点击
extension UYEmployViewController:UYOrderBaseInfoViewDelegate {
    //添加就业进展
    func addEmploymentProgressAction() {
//        let orderInfo = orderList[currentIndex]
        pushToNextVC(nextVC: UYAddJobViewController())
    }
    //我已就业
    func haveJobsAction() {
        let orderInfo = orderList[currentIndex]
        pushToNextVC(nextVC: UYAddJobViewController())

    }
    //申请理赔
    func applyReparations() {
        let orderInfo = orderList[currentIndex]

    }
    // 理赔记录
    func compensationRecords() {
        let orderInfo = orderList[currentIndex]

    }
}
// MARK: - 网络请求
extension UYEmployViewController {
    @objc fileprivate func loadOrderList(isRefash:Bool = false) {
        showWaitToast()
        if isRefash {
            page  = 1
        }
        request.getOrderList(page: page) {[weak self] (orderList, error) -> (Void) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
                self?.hasMore = false
            }else{
                dismissWaitToast()
                if orderList?.insured_order != nil {
                    self?.hiddenErrorView()
                   self?.totlePage = orderList?.page?.totalPage ?? 1
                    self?.titleLabel.text = "\((self?.page)!)/\(self?.totlePage ?? 0)"
                    if isRefash {
                        self?.page = 1
                        self?.orderList.removeAll()
                    }else{
                        self?.page  = (self?.page)! + 1
                    }
                    self?.orderList.append((orderList?.insured_order)!)
                 

                    if (orderList?.page?.totalCount ?? 0) > (self?.orderList.count ?? 0) {
                        self?.hasMore = true
                        if self?.page == 2 {
                            self?.shakeCollectionView()
                        }
                    }else {
                        self?.hasMore = false
                    }
                    self?.orderCollectionView.reloadData()
                }
            }
        }
    }
}
