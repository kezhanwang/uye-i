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
    @IBOutlet weak var orderCollectionView: UICollectionView!
    fileprivate var orderList:[UYOrderModel] = []
    fileprivate var hasMore = false //是否还有更多，默认是没有的
    fileprivate var page:Int = 1 //从第一页开始
    fileprivate var totlePage :Int = 1//默认也是1
    fileprivate var titleLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "就业帮"
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
        titleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(21)
            make.width.equalTo(30)
        }
        
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

// MARK: - 有订单的列表
extension UYEmployViewController {
    func loadCollectionView()  {
        orderCollectionView.backgroundColor = UIColor.background
        orderCollectionView.register(UINib(nibName: "UYOrderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: orderCelIdentifier)
        orderCollectionView.snp.updateConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.bottom.equalTo(-(tabBarController?.tabBar.frame.height)!)
        }
    }
    func shakeCollectionView() {
        var shakeTime = UserDefaults.standard.integer(forKey: "com.uy.shake.time")
        if shakeTime < 2 {
            DispatchQueue.main.async {
                self.showTextToastAutoDismiss(msg: "向左滑动查看更多订单哦", second: 3)
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
            UserDefaults.standard.synchronize()
        }else{
            UserDefaults.standard.set(0, forKey: "com.uy.shake.time")
            UserDefaults.standard.synchronize()
        }
        
    }
}
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
        let indexPage:Int = Int(scrollView.contentOffset.x/kScreenWidth)+1
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

// MARK: - 网络请求
extension UYEmployViewController {
    @objc fileprivate func loadOrderList(isRefash:Bool = false) {
        showWaitToast()
        if isRefash {
            page  = 1
        }
        request.getOrderList(page: page) {[weak self] (orderList, error) -> (Void) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
                self?.hasMore = false
            }else{
                self?.dismissToast()
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
