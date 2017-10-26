//
//  UYQuestionnaireViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
let answerCellIdentifier = "answerCellIdentifier"
let questionHeaderIdentifier = "questionHeaderIdentifier"

class UYQuestionnaireViewController: UYBaseViewController {
    var org_id:String?
    
    fileprivate var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    fileprivate var questionList:UYQuestionList?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "问卷调查"
        getQeustionList()
    }
    override func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavigationHeight)
            make.left.right.bottom.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        let tableHeadView = UYTipsHeadView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 25))
        tableHeadView.title = "请您配合问卷调查，我们会为您提供更好的服务"
        tableView.tableHeaderView = tableHeadView
        let footView = UYTableFooterView(title: "下一步")
        footView.delegate = self
        tableView.tableFooterView = footView
        tableView.register(UINib(nibName: "UYAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: answerCellIdentifier)
        tableView.register(UYQuestionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: questionHeaderIdentifier)
    }

}

// MARK: - 网络请求
extension UYQuestionnaireViewController {
    func getQeustionList() {
        showWaitToast()
        
        request.getQuestionListRequest(orgId: org_id ?? "") {[weak self] (questionList, error) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.questionList = questionList
                if self?.questionList?.need_question == true {
                    self?.tableView.reloadData()
                }else{
                    self?.footButtonAction()
                }
            }
        }
    }
    func uploadLoadAnsowers() {
        showWaitToast()
        var questions:[Any] = [Any]()
        
        for question in (questionList?.questions)! {
            var answer:[String] = [String]()
            for answor in question.selectAnswer {
                answer.append(answor)
            }
            let que :[String : Any] = ["id":question.id ?? "",
                                       "answer":answer]
            questions.append(que)
        }
//        let ques:[String:Any] = ["question":questions]
        
        let data : NSData! = try? JSONSerialization.data(withJSONObject: questions, options: []) as NSData!
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)! as String

        request.submitQuestionAnswer(orgId:org_id ?? "", answers: JSONString) {[weak self] (error) -> (Void) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                let userInfoVC = UYUserInfoViewController()
                userInfoVC.order_id = self?.org_id ?? ""
                self?.pushToNextVC(nextVC: userInfoVC)
            }
        }
    }
}
extension UYQuestionnaireViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questionList?.questions?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let queston = questionList?.questions![section] {
            return queston.answer?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: answerCellIdentifier, for: indexPath) as!  UYAnswerTableViewCell
        if let queston = questionList?.questions![indexPath.section] {
            if let ansower = questionList?.questions![indexPath.section].answer![indexPath.row] {
                cell.nameLabel.text = ansower
                if queston.selectAnswer.contains(ansower) {
                    cell.selectBtn.isSelected = true
                }else{
                    cell.selectBtn.isSelected = false
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: questionHeaderIdentifier) as! UYQuestionHeaderView
        if let question = questionList?.questions![section] {
            headView.question = question
        }
        return headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let question = questionList?.questions![section] {
            return UYQuestionHeaderView.heightWithQuestion(question: question)
        }
        return 10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let queston = questionList?.questions![indexPath.section] {
            if let ansower = questionList?.questions![indexPath.section].answer![indexPath.row] {
                if queston.selectAnswer.contains(ansower) {
                    queston.selectAnswer.remove(ansower)
                }else{
                    if queston.type == "2" {
                        queston.selectAnswer.insert(ansower)
                    }else{
                        if queston.selectAnswer.count > 0 {
                            queston.selectAnswer.removeAll()
                        }
                        queston.selectAnswer.insert(ansower)
                    }
                }
                tableView.reloadData()
            }
        }
    }
}
extension UYQuestionnaireViewController : UYTableFooterViewDelegate {
    func footButtonAction() {
        uploadLoadAnsowers()
//        let userInfoVC = UYUserInfoViewController()
//        userInfoVC.order_id = self.org_id!
//        pushToNextVC(nextVC: userInfoVC)
    }
}
