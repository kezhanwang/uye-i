//
//  UYMonthDatePicker.swift
//  uye
//
//  Created by Tintin on 2017/11/7.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
//为了显示无限循环假象，就设置循环的次数
fileprivate let maxCycleCount = 100
fileprivate let bgViewHeight :CGFloat = 216+66
typealias DatePickerHandler = (String) -> ()
/// 只是展示年月的日期选择器；例如 2017-11 
class UYMonthDatePicker: UYBaseActionSheetView {

    /// 是否包含至今
    var isContainNow = false {
        didSet {
            if isContainNow {
                if yearArray.last != "至今" {
                    yearArray.append("至今")
                }
            }else{
                yearArray.removeAll()
                for index in currentYear-100...currentYear+100 {
                    yearArray.append("\(index)")
                }
            }
        }
    }
    
    /// 设置最小的日期,格式为：YYYY-MM
    var minDate:String! {
        didSet {
            guard minDate.count > 0 else {
                return
            }
            let minDateArray = minDate?.components(separatedBy: "-")
            guard minDateArray?.count == 2 else {
                return
            }
            minYear = Int((minDateArray?.first)!) ?? 1917
            minMonth = Int((minDateArray?.last)!) ?? 1
            
            if minYear > currentYear {
                defaultDate = minDate
            }else if minYear == currentYear {
                if minMonth > currentMonth {
                    defaultDate = minDate
                }
            }
        }
    }
    fileprivate var minYear:Int = 1917
    fileprivate var minMonth:Int = 1
    /// 设置最大的日期,格式为：YYYY-MM，默认是至今
    var maxDate:String! {
        didSet {
            guard maxDate.count > 0 else {
                return
            }
            if maxDate == "至今" {
                return
            }
            let maxDateArray = maxDate?.components(separatedBy: "-")
            guard maxDateArray?.count == 2 else {
                return
            }
            maxYear = Int((maxDateArray?.first)!) ?? 3000
            maxMonth = Int((maxDateArray?.last)!) ?? 13
            
            if maxYear < currentYear {
                defaultDate = maxDate
            }else if maxYear == currentYear {
                if maxMonth < currentMonth {
                    defaultDate = maxDate
                }
            }
            
        }
    }
    fileprivate var maxYear:Int = 3000
    fileprivate var maxMonth:Int = 13
    
    var nowDate:String!
    
    //设置默认展示的日期,默认是当前的年月
    var defaultDate:String! {
        didSet {
            guard defaultDate.count > 0 else {
                return
            }
            let dateArray = defaultDate.components(separatedBy: "-")
            guard dateArray.count == 2 else {
                return
            }
            defaultYear = Int(dateArray.first!) ?? 2017
            defaultMonth = Int(dateArray.last!) ?? 1
        }
    }
    /// 默认展示的年
    fileprivate var defaultYear : Int = 2016
    /// 默认展示的月份
    fileprivate var defaultMonth :Int = 1
    
    fileprivate var dateHandler :DatePickerHandler?

    
    /// 年的数组
    fileprivate var yearArray = [String]()
    /// 月的数组
    fileprivate var monthArray = [String]()
    /// 当前的年月
    fileprivate var currentYear : Int = 2016
    /// 当前的月份
    fileprivate var currentMonth : Int = 1
    
    /// datePicker
    fileprivate var dataPicker = UIPickerView()
    fileprivate var backView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initDataPicker()
        initYearArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func showActionSheet() {
        super.showActionSheet()
        backView.snp.updateConstraints { (make) in
            make.bottom.equalTo(0)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    override func dismissActionSheet() {
        super.dismissActionSheet()
        backView.snp.updateConstraints { (make) in
            make.bottom.equalTo(bgViewHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func selectDateFinish(complete:@escaping DatePickerHandler)  {
        dateHandler = complete
    }
}

// MARK: - 数据处理
extension UYMonthDatePicker {
    func initYearArray()  {
        let currentDate = Date()
        let currentCalendar = Calendar.current
        
        let componentsSet = Set<Calendar.Component>([.year, .month])
        let componentss = currentCalendar.dateComponents(componentsSet, from: currentDate)
        
        currentYear = componentss.year!
        currentMonth = componentss.month!
        
        nowDate = "\(currentYear)-\(currentMonth)"
        
        defaultYear = currentYear
        defaultMonth = currentMonth
        defaultDate = "\(defaultYear)-\(defaultMonth)"
        
        yearArray.removeAll()

        for index in currentYear-100...currentYear {
            yearArray.append("\(index)")
        }
        monthArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    }
    
    func refashDate() {
        let indexRow0 = yearArray.index(of: "\(defaultYear)") ?? 0
        let indexRow1 = monthArray.index(of: "\(defaultMonth)") ?? 0
        
        let row0 = (maxCycleCount/2)*yearArray.count + indexRow0
        let row1 = (maxCycleCount/2)*monthArray.count + indexRow1
        
        dataPicker.selectRow(row0, inComponent: 0, animated: false)
        dataPicker.selectRow(row1, inComponent: 1, animated: false)
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async {
            self.dataPicker.reloadAllComponents()
            DispatchQueue.main.async {
                print("为什么老是展示")
                self.refashDate()
            }
        }
        
    }
}
extension UYMonthDatePicker {
    func initDataPicker() {
        addSubview(backView)
        backView.backgroundColor = UIColor.white
        backView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(bgViewHeight)
            make.height.equalTo(bgViewHeight)
        }
        backView.addSubview(dataPicker)
        dataPicker.snp.makeConstraints { (make) in
            make.top.equalTo(44)
            make.left.right.bottom.equalTo(0)
        }
        dataPicker.dataSource = self
        dataPicker.delegate = self
        
        let leftBtn = UIButton()
        backView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(0)
            make.height.equalTo(44)
//            make.width.equalTo(80)
        }
        leftBtn.setTitle("取消", for: UIControlState.normal)
        leftBtn.setTitleColor(UIColor.themeColor, for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(cancelSelectDate), for: .touchUpInside)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        let rightBtn = UIButton()
        backView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.top.equalTo(0)
            make.height.equalTo(44)
//            make.width.equalTo(80)
        }
        rightBtn.setTitleColor(UIColor.themeColor, for: UIControlState.normal)
        rightBtn.setTitle("确定", for: UIControlState.normal)
        rightBtn.addTarget(self, action: #selector(makeSureSelectDate), for: .touchUpInside)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lineGray
        backView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(44)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        let titleLabel = UILabel()
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(44)
            make.centerX.equalTo(backView)
        }
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.placeholderText
        titleLabel.text = "请选择日期"
        
        
    }
    @objc func cancelSelectDate()  {
        dismissActionSheet()
    }
    @objc func makeSureSelectDate() {
        if self.dateHandler != nil {
            let yearRow = dataPicker.selectedRow(inComponent: 0)
            let year = yearArray[yearRow%yearArray.count]
            
            if year == "至今" {
                self.dateHandler!(year)
            }else{
//                var index = year.index(of: "年")
//                year = String(year.prefix(upTo: index!))
                
                let monthRow = dataPicker.selectedRow(inComponent: 1)
                let month = monthArray[monthRow%monthArray.count]
//                index = month.index(of: "月")
//                month = String(month.prefix(upTo: index!))
                
                self.dateHandler!("\(year)-\(month)")
            }
        }
        dismissActionSheet()
    }
   
}
extension UYMonthDatePicker :UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return maxCycleCount * yearArray.count
        }else{
            return maxCycleCount * monthArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let year = yearArray[row%yearArray.count]
            if year == "至今" {
                return year
            }else{
                return "\(year)年"
            }
        }else{
            if (monthArray.count > row%12) {
                return "\(monthArray[row%12])月"
            }else{
                return "--"
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { //滚动年份
            let year = yearArray[row%yearArray.count]
            
            if year == "至今" {
                monthArray.removeAll()
                pickerView.reloadComponent(1)
            }else{
                //如果年的值不在可选范围内，则年滚到可选的范围内
                var yearInt = Int(year)!
                if yearInt < minYear || yearInt > maxYear {
                    if yearInt < minYear {
                        yearInt = minYear
                    }
                    if yearInt > maxYear {
                        yearInt = maxYear
                    }
                    let indexRow0 = yearArray.index(of: "\(yearInt)") ?? 0
                    let yearRow = (maxCycleCount/2)*yearArray.count + indexRow0
                    pickerView.selectRow(yearRow, inComponent: 0, animated: true)
                }
                //当年的值选择完毕，判断月的值是否可以选则，如果月份不在可选范围内，则滚动到对应月份
                let monthRow = pickerView.selectedRow(inComponent: 1)
                let month = monthArray[monthRow%monthArray.count]
                var monthInt = Int(month)!
                
                if yearInt == minYear || yearInt == maxYear || yearInt == currentYear {
                    if yearInt == minYear {//如果是判定最小年限
                        var realMinMonth = minMonth
                        if yearInt == currentYear {
                            realMinMonth = currentMonth < minMonth ? currentMonth : minMonth
                        }
                        if monthInt < realMinMonth {
                            monthInt = realMinMonth
                            
                            let indexRow0 = monthArray.index(of: "\(monthInt)") ?? 0
                            let monthRow = (maxCycleCount/2)*monthArray.count + indexRow0
                            pickerView.selectRow(monthRow, inComponent: 1, animated: true)
                        }
                    }else if yearInt == maxYear {//如果是判定越大年限
                        var realMinMonth = minMonth
                        if yearInt == currentYear {
                            realMinMonth = currentMonth > maxMonth ? maxMonth : currentMonth
                        }
                        if monthInt > realMinMonth {
                            monthInt = realMinMonth
                            let indexRow0 = monthArray.index(of: "\(monthInt)") ?? 0
                            let monthRow = (maxCycleCount/2)*monthArray.count + indexRow0
                            pickerView.selectRow(monthRow, inComponent: 1, animated: true)
                        }
                    }else if yearInt == currentYear {
                        if monthInt > currentMonth {
                            monthInt = currentMonth
                            let indexRow0 = monthArray.index(of: "\(monthInt)") ?? 0
                            let monthRow = (maxCycleCount/2)*monthArray.count + indexRow0
                            pickerView.selectRow(monthRow, inComponent: 1, animated: true)
                        }
                    }
                }
                
                if monthArray.count != 12 {
                    monthArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
                    pickerView.reloadComponent(1)
                }
            }
        }else{
            let yearRow = pickerView.selectedRow(inComponent: 0)
            let year = yearArray[yearRow%yearArray.count]
            let yearInt = Int(year)!
            
            //当年的值选择完毕，判断月的值是否可以选则，如果月份不在可选范围内，则滚动到对应月份
            let month = monthArray[row%monthArray.count]
            var monthInt = Int(month)!
            
            if yearInt == minYear || yearInt == maxYear || yearInt == currentYear {
                if yearInt == minYear {//如果是判定最小年限
                    var realMinMonth = minMonth
                    if yearInt == currentYear {
                        realMinMonth = currentMonth < minMonth ? currentMonth : minMonth
                    }
                    if monthInt < realMinMonth {
                        monthInt = realMinMonth
                        
                        let indexRow0 = monthArray.index(of: "\(monthInt)") ?? 0
                        let monthRow = (maxCycleCount/2)*monthArray.count + indexRow0
                        pickerView.selectRow(monthRow, inComponent: 1, animated: true)
                    }
                }
                if yearInt == maxYear {//如果是判定越大年限
                    var realMinMonth = minMonth
                    if yearInt == currentYear {
                        realMinMonth = currentMonth > maxMonth ? maxMonth : currentMonth
                    }
                    if monthInt > realMinMonth {
                        monthInt = realMinMonth
                        let indexRow0 = monthArray.index(of: "\(monthInt)") ?? 0
                        let monthRow = (maxCycleCount/2)*monthArray.count + indexRow0
                        pickerView.selectRow(monthRow, inComponent: 1, animated: true)
                    }
                }
                if yearInt == currentYear {
                    if monthInt > currentMonth {
                        monthInt = currentMonth
                        let indexRow0 = monthArray.index(of: "\(monthInt)") ?? 0
                        let monthRow = (maxCycleCount/2)*monthArray.count + indexRow0
                        pickerView.selectRow(monthRow, inComponent: 1, animated: true)
                    }
                }
            }
        }
    }
}
