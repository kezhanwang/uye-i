//
//  KZBaseViewController.swift
//  kezhan
//
//  Created by Tintin on 2017/5/6.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit

class KZBaseViewController: UIViewController {
    
    var tableView :UITableView?
    var refashControl :UIRefreshControl?
    var isPullup = false
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navigationBarHeight))
    lazy var navigationItemKZ = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayViewColor()
        setupUI()
        loadData()
    }
    
    
    override var title: String? {
        didSet {
            navigationItemKZ.title = title
        }
    }
    deinit {
        print("\(self)释放啦")
    }
   
}

// MARK: - 加载数据
extension KZBaseViewController {
    func loadData(){
        refashControl?.endRefreshing()
    }
}
// MARK: - 设置界面
extension KZBaseViewController {
    func setupUI(){
        setupNavigation()
        setupTableView()

    }
    
    /// 设置添加navigationBar和navigationItemKZ，所有的View都应该在这个View之下
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(navigationBar)
        navigationBar.barTintColor = UIColor.init(red: 0, green: 165.0/255, blue: 240.0/255, alpha: 1)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 20)];
        navigationBar.items = [navigationItemKZ]
        
    }
    ///设置tableView
    func setupTableView(style:UITableViewStyle = .plain) {
        
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView.init(frame: view.bounds, style: style)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.backgroundColor = UIColor.grayViewColor()
        tableView?.rowHeight = 45
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? tabbarHeight, 0)
        tableView?.showsHorizontalScrollIndicator = false
        view.insertSubview(tableView!, belowSubview: navigationBar)
    }
    func setupRefashControl() {
        refashControl = UIRefreshControl()
        tableView?.addSubview(refashControl!)
        refashControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
}
// MARK: - UITableViewDelegate && DataSource
extension KZBaseViewController : UITableViewDelegate,UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
   
    //上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if refashControl != nil {
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0  {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        
        if row == count-1 && !isPullup {
            print("需要上拉刷新？？？")
            
                isPullup = true
                loadData()
        }
        }
    }
}

// MARK: - 界面切换的快捷方法
extension KZBaseViewController {
    func pushToNextVC(nextVC :UIViewController) {
        view.endEditing(false)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    func popBackAction() {
        navigationController?.popViewController(animated: true)
    }
    func popToViewController(targetVC :UIViewController) {
        navigationController?.popToViewController(targetVC, animated: true)
    }
}
