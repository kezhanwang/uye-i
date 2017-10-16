//
//  UYSearchViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYSearchViewController: UYBaseViewController {
    
    let tagsView :UIView = UIView()
    let tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    let searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
    }
    override func setupUI() {
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "请输入您要搜索的机构名称"
        changeSearchBarCancelBtnTitleColor(view: searchBar)
        searchBar.becomeFirstResponder()
        addTagsView()
    }

}
// MARK: - 网络请求数据加载
extension UYSearchViewController {
    func getOrganiseList(isRefash:Bool = true) {
        showWaitToast()
        request.getOrganiseList(isRefash: isRefash, word: "上海") {[weak self] (list, error) -> (Void) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
            }
        }
    }
    
}

// MARK: - 设置页面之热门搜索和历史记录
extension UYSearchViewController {
    func addTagsView() {
        view.addSubview(tagsView)
        tagsView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaHeight)
            make.left.right.bottom.equalTo(0)
        }
        let hotSearch:UYTagView = UYTagView(title: "热门搜索")
        hotSearch.tagsArray = ["翡翠","华育","IT","完美东流","健身","英语","设计"]
        tagsView.addSubview(hotSearch)
        hotSearch.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalTo(0)
            make.height.equalTo(hotSearch.estimatedHeight)
        }
        
        let historyView:UYTagView = UYTagView(title: "历史记录", showDelete: true)
        historyView.tagsArray = ["翡翠","华育","IT","完美东流","健身","英语","设计"]
        tagsView.addSubview(historyView)
        historyView.snp.makeConstraints { (make) in
            make.top.equalTo(20+hotSearch.estimatedHeight)
            make.left.right.equalTo(0)
            make.height.equalTo(historyView.estimatedHeight)
        }
    }
}

// MARK: - 设置页面之搜索无结果页面
extension UYSearchViewController {
    
}

// MARK: - 搜索有结果页面
extension UYSearchViewController {
    
}



// MARK: - SearchBarDelegate
extension UYSearchViewController :UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        popBackAction()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        changeSearchBarCancelBtnTitleColor(view: searchBar)
    }
    func changeSearchBarCancelBtnTitleColor(view:UIView) {
        if view.isKind(of: UIButton.self) {
            let getBtn = view as! UIButton
            
            getBtn.isEnabled = true
            getBtn.isUserInteractionEnabled = true
            return;
        }else{
            for subView in view.subviews {
                changeSearchBarCancelBtnTitleColor(view: subView)
            }
        }
    }
}


