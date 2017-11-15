//
//  UYPlaceOrderViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/19.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let cellInputIdentifier = "cellIdentifier"
fileprivate let orderOrganiseIdentifier = "orderOrganiseIdentifier"
fileprivate let cellInputBtnIdentifier = "inputcellIdentifier"
fileprivate let uploadCellIdentifier = "uploadCellIdentifier"
class UYPlaceOrderViewController: UYBaseViewController {
    var order_id :String = ""
    fileprivate var organiseConfig:UYOrganiseConfig?
    fileprivate var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    fileprivate var dataArray:[UYInputModel] = []
    fileprivate var imageInputModel:UYInputModel = UYInputModel(title: "手持身份证照片", placeholder: "注：请持本人身份证，在有机构LOGO的地方与课程顾问一期进行拍摄，要求照片清晰无遮挡")
    fileprivate var agreeInputModel:UYInputModel = UYInputModel(title: "培训协议", placeholder: "注：请上传培训协议或收据，需要机构名称、课程、价格、时间等重要信息")

    fileprivate let uploadManager = UYUploadPhotoManager()
    fileprivate var datePicker = KZDatePickerView()
    fileprivate let footView = UYTableFooterView(title: "提交")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "机构信息"
        loadLocalData()
        getOragniseInfo()
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
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(UINib(nibName: "UYInputTableViewCell", bundle: nil), forCellReuseIdentifier: cellInputIdentifier)
        tableView.register(UINib(nibName: "UYInputBtnTableViewCell", bundle: nil), forCellReuseIdentifier: cellInputBtnIdentifier)
        tableView.register(UYUploadImageTableViewCell.classForCoder(), forCellReuseIdentifier: uploadCellIdentifier)
        tableView.register(UINib(nibName: "UYOrganiseOrderTableCell", bundle: nil), forCellReuseIdentifier: orderOrganiseIdentifier)
        
        footView.addOrderSubview()
        footView.delegate = self
        tableView.tableFooterView = footView
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
    }
    
}
extension UYPlaceOrderViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return dataArray.count
        }
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: orderOrganiseIdentifier, for: indexPath) as! UYOrganiseOrderTableCell
            cell.organise = organiseConfig?.organize
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellInputIdentifier, for: indexPath) as! UYInputTableViewCell
            cell.indexPath = indexPath
            let inputModel :UYInputModel = dataArray[indexPath.row]
            cell.inputModel = inputModel
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: uploadCellIdentifier, for: indexPath) as! UYUploadImageTableViewCell
            if indexPath.row == 0 {
                cell.indexPath = indexPath
                cell.delegate = self
                cell.isMultipleUpload = false
                cell.titleLabel.text = imageInputModel.title
                cell.tipsLabel.text = imageInputModel.placeholder
                if let url = URL(string: imageInputModel.image1) {
                    cell.uploadButton.kf.setImage(with: url, for: UIControlState.normal)
                }
            }else {
                cell.indexPath = indexPath
                cell.delegate = self
                cell.isMultipleUpload = true
                cell.name = "training_pic"
                cell.titleLabel.text = agreeInputModel.title
                cell.tipsLabel.text = agreeInputModel.placeholder
                cell.images = agreeInputModel.images
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return UYUploadImageTableViewCell.getHeight(count: 0)
            }else{
                return UYUploadImageTableViewCell.getHeight(count: agreeInputModel.images?.count ?? 0)
            }
        }
        return 46
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 5
        }
        return 0.1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {//课程选择
                view.endEditing(false)
                var coursename = [String]()
                guard organiseConfig != nil else{ return }
                guard organiseConfig?.courses?.count ?? 0 > 0 else{ return }
                for course in (organiseConfig?.courses)! {
                    coursename.append(course.c_name!)
                }
                if coursename.count > 0 {
                    var inputModel :UYInputModel = dataArray[indexPath.row]

                    let dataPicker = KZDataPicker(mutableComponent: false, dataArray: coursename)
                    dataPicker?.showSinglePicker(pickerSelect: {[weak self] (name, finish) in
                        if finish {
                            inputModel.content = name!
                            for course in (self?.organiseConfig?.courses)! {
                                if name == course.c_name {
                                    inputModel.subContent = course.c_id ?? ""
                                    break;
                                }
                            }
                            self?.dataArray[indexPath.row] = inputModel
                            self?.tableView.reloadData()
                        }
                    })
                }
                
            }else if indexPath.row == 3 {//培训日期开始
                let years70:TimeInterval = 24*60*60*365*70
                let maxDate = Date(timeIntervalSinceNow: 24*60*60*365*70)
                let minDate = Date(timeIntervalSinceNow: -years70)
                showDatePicer(maxDate: maxDate, minDate: minDate, indexPath: indexPath)
            }else if indexPath.row == 4 {////培训日期结束
                let minDate = Date(timeIntervalSinceNow: -24*60*60*365*70)
                let maxDate = Date(timeIntervalSinceNow: 24*60*60*365*70)
                showDatePicer(maxDate: maxDate, minDate: minDate, indexPath: indexPath)
            }
        }
    }
}

// MARK: - 日期选择器
extension UYPlaceOrderViewController {
    func showDatePicer(maxDate:Date,minDate:Date,indexPath:IndexPath) {
        self.view.endEditing(false)
        var inputModel :UYInputModel = dataArray[indexPath.row]
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        if inputModel.content.isEmpty == false {
            let nowDate = NSDate(from: inputModel.content)! as Date
            
            if (nowDate < minDate  || nowDate > maxDate) {
                datePicker.beginDate = minDate
            }else{
                datePicker.beginDate = nowDate
            }
        }
        datePicker.showDatePickerComolete {[weak self] (date) in
            inputModel.content = date ?? ""
            self?.dataArray[indexPath.row] = inputModel
            self?.tableView.reloadData()
        }
    }
}

// MARK: - 图片上传
extension UYPlaceOrderViewController :UYInputTableViewCellDelegate {
    func textFieldTextDidChange(indexPath: IndexPath, text: String) {
        var inputModel = dataArray[indexPath.row]
        inputModel.content = text
        dataArray[indexPath.row] = inputModel
    }
    func uploadImageAction(indexPath: IndexPath, index: Int) {
        if uploadManager.isUploading {
            return
        }
        if indexPath.row == 0 {//上传手持身份证照片
            self.view.endEditing(false)
            let group_pic = "group_pic"
            uploadManager.uploadImage(tipsImage: "", name: group_pic, complete: {[weak self] (result) in
                self?.imageInputModel.image1 = result[group_pic] as! String
                self?.tableView.reloadData()
            })
        }else{//上传培训协议
            if index == 0 {
                
                let firstUrl = agreeInputModel.images!["training_pic_0"] ?? ""
                var isFull = false
                if firstUrl.count > 0 {
                    isFull = true
                }
                if isFull {
                    uploadTrainingPic(index: 0)
                    return
                }else{
                    var currentCount = agreeInputModel.images!.count //从1开始，0留给上传按钮
                    if currentCount == 9 {
                        currentCount = 0
                    }
                    uploadTrainingPic(index: currentCount)
                    return
                }
                /*没测试成功，太大，超时了
                 let currentCount = agreeInputModel.images!.count //从1开始，0留给上传按钮
                let maxCount = 10 - currentCount
                uploadManager.uploadMultipleImages(name: "training_pic", beginIndex: currentCount, maxCount: maxCount, complete: {[weak self] (result) in
                    for (key, value) in result {
                        if key == "training_pic_9" {
                            self?.agreeInputModel.images!["training_pic_0"] = (value as! String)
                        }else{
                            self?.agreeInputModel.images![key] = (value as! String)
                        }
                    }
                    self?.tableView.reloadData()
                })
           */
            }else{
               uploadTrainingPic(index: index)
            }
        }
    }
    func uploadTrainingPic(index:Int)  {
        self.view.endEditing(false)
        let training_pic = "training_pic_\(index)"
        uploadManager.uploadImage(tipsImage: "", name: training_pic, complete: {[weak self] (result) in
            for (key, value) in result {
                self?.agreeInputModel.images![key] = (value as! String)
            }
            self?.tableView.reloadData()
        })
    }
}
// MARK: - 本地数据的处理
extension UYPlaceOrderViewController {
    
    /// 加载本地数据
    func loadLocalData()  {
        let courseNameItem = UYInputModel(title: "课程名字", placeholder: "请选择您学习的课程名称", textFieldEnable: false)
        let priceItem = UYInputModel(title: "学费金额", placeholder: "请输入您实际学费金额(元)", keyboardType: UIKeyboardType.numberPad)
        let classItem = UYInputModel(title: "班级名称", placeholder: "请输入您所在班级的名称")
        let beginDate = UYInputModel(title: "培训日期", placeholder: "请选择开始日期",textFieldEnable: false)
        let endDate = UYInputModel(placeholder: "请选择证结束日期", textFieldEnable: false)
        let consultantName = UYInputModel(title: "课程顾问", placeholder: "请输入您课程顾问的姓名")
        dataArray.append(courseNameItem)
        dataArray.append(priceItem)
        dataArray.append(classItem)
        dataArray.append(beginDate)
        dataArray.append(endDate)
        dataArray.append(consultantName)
        agreeInputModel.images = ["training_pic_0":""]
    }
 
}
extension UYPlaceOrderViewController:UYTableFooterViewDelegate {
    func checkParameters() -> Bool {
        for model:UYInputModel in dataArray {
            guard model.content.count > 0 else {
                showTextToast(msg: model.placeholder)
                return false
            }
        }
        guard imageInputModel.image1.count > 0 else {
            showTextToast(msg: imageInputModel.placeholder)
            return false
        }
        
        var hasValue = false
        
        for (_,value) in agreeInputModel.images! {
            if value.count > 0 {
                hasValue = true
            }
        }
        guard hasValue else {
            showTextToast(msg: agreeInputModel.placeholder)
            return false
        }
        guard footView.orderAgreedAgreement else {
            showTextToast(msg: "请阅读并同意服务条款")
            return false
        }
        return true
    }
    func loadParameters() -> [String:Any] {
                let courseName :UYInputModel = dataArray[0]
                let price :UYInputModel = dataArray[1]
                let className :UYInputModel = dataArray[2]
                let beginDate :UYInputModel = dataArray[3]
                let endDate :UYInputModel = dataArray[4]
                let consultant :UYInputModel = dataArray[5]
                let pirce_fen = (Int(price.content) ?? 0) * 100
        
        
        var training_pic :String = ""
        var aImages:[String:String] = [:]
        for (key,value) in agreeInputModel.images! {
            if value.count > 0 {
                aImages[key] = value
            }
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: aImages, options: JSONSerialization.WritingOptions.prettyPrinted) {
            training_pic = String(data: data, encoding: String.Encoding.utf8) ?? ""
        }
        
        return ["org_id":order_id,
                "c_id":courseName.subContent,
                "tuition":"\(pirce_fen)",
                "class":className.content,
                "class_start":beginDate.content,
                "class_end":endDate.content,
                "course_consultant":consultant.content,
                "group_pic":imageInputModel.image1,
                "training_pic":training_pic,
                "insured_type":"1",
        ]
    }
    // MARK: 提交数据
    
    func footButtonAction() {
        
        guard checkParameters() else { return }
        let parameters = loadParameters()

        request.submitOrderInfo(parameters: parameters) {[weak self] (error) -> (Void) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                showTextToast(msg: "提交成功")
                NotificationCenter.default.post(name: MakeOrderSuccess, object: nil)
                self?.popToRootViewController(after: 3)
            }
        }
    }
    //展示U授权协议
    func showAuthoriseAgreementAction() {
//        let webVC = UYWebViewController()
//        webVC.urlString = ServiceAgreementURLString
//        pushToNextVC(nextVC: webVC)
    }
    //展示服务协议
    func showOrderServiceAgreement() {
        
        let webVC = UYWebViewController()
        webVC.urlString = UYRequestAPI.orderAgreement.requestURLString()
        pushToNextVC(nextVC: webVC)
    }

}

// MARK: - 网络请求
extension UYPlaceOrderViewController {
    func getOragniseInfo()  {
        showWaitToast()
        request.getOrderOrganiseConfig(orgId: order_id) {[weak self] (organiseConfig, error) in
            if error != nil {
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                self?.organiseConfig = organiseConfig
                self?.tableView.reloadData()
            }
            
        }
    }
}
