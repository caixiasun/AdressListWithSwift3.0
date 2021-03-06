//
//  ContactController.swift
//  AdressListWithSwift2
//
//  Created by caixiasun on 16/9/7.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

let searchViewHeight:CGFloat = 45
let ContactCellHeight:CGFloat = 70
let ContactSectionHeight:CGFloat = 50

class ContactController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ContactModelDelegate ,YTOtherLibToolDelegate{
    
    var searchView:UIView?
    var textField:UITextField?
    var searchLab:UILabel?
    var searchImg:UIImageView?
    var searchCoverView:UIView?
    
    var tableView:UITableView?
    var dataSource:NSMutableArray?
    var sectionArray:NSMutableArray?
    let cellReuseIdentifier = "AdressListCell"
    let headerIdentifier = "HeaderReuseIdentifier"
    var messageView:MessageView?
    let contactModel:ContactModel = ContactModel()
    var localDataSource:NSMutableArray?
    var otherlibTool = YTOtherLibTool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNaviBar()
        
        self.initSearchView()

        self.initSubviews()
        
        self.view.bringSubview(toFront: searchCoverView!)
        
        self.messageView = addMessageView(InView: self.view)
        self.contactModel.delegate = self
        self.otherlibTool.delegate = self
        if dataCenter.isAlreadyLogin() {
            self.messageView?.setMessageLoading()
            self.downpullRequest()
        }
        
        otherlibTool.addDownPullAnimate(InView: self.tableView!)
        
        //登录成功后收到通知，刷新本界面
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: kNotification_refresh_contact_index_from_login), object: nil)
        
    }
    func refresh()
    {
        self.downpullRequest()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView?.stopLoading()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotification_refresh_contact_index_from_login), object: nil)
    }
    func downpullRequest() {
        //请求列表
        self.contactModel.requestContactList()
    }
    
    //MARK:- init method
    func initNaviBar()
    {
        self.navigationItem.title = "所有联系人"
        let addBtn = YTDrawButton(frame: CGRect(x:0, y:0, width:kNavigationBar_button_w, height:kNavigationBar_button_w), Img: UIImage(named: "add.png"), Target: self, Action: #selector(ContactController.addAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
    }
    
    func initSearchView()
    {
        let searchColor = colorWithHexString(hex: "E0E0E0")
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: searchViewHeight))
        bgView.backgroundColor = searchColor
        self.view.addSubview(bgView)
        
        let searchView = UIView()
        searchView.frame = CGRect(x:6, y:7.5, width:kScreenWidth-12, height:30)
        setCornerRadius(view: searchView, radius: 15)
        searchView.backgroundColor = WhiteColor
        bgView.addSubview(searchView)
        
        let w:CGFloat = 15.0
        let centerX = kScreenWidth*0.5;
        let centerY:CGFloat = 15
        let searchImg = UIImageView()
        setYTSize(obj: searchImg, size: CGSize(width:w, height:w))
        //设置searchImg的右为searchLab的左-5
        setYTRight(obj: searchImg, right: centerX-35)
        setYTCenterY(obj: searchImg, y: centerY)
        searchImg.image = UIImage(named: "search.png")
        searchView.addSubview(searchImg)
        self.searchImg = searchImg
        
        let textField = UITextField()
        textField.frame = CGRect(x:6, y:0, width:kScreenWidth*0.5, height:30)
        setCornerRadius(view: textField, radius: 10)
        setYTLeft(obj: textField, left: getYTRight(obj: self.searchImg!)+6)
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: 16)
        searchView.addSubview(textField)
        self.textField = textField
        
        let searchLab = UILabel()
        setYTSize(obj: searchLab, size: CGSize(width:85, height:20))
        setYTLeft(obj: searchLab, left: getYTRight(obj: self.searchImg!)+6)
        setYTCenterY(obj: searchLab, y: centerY)
        searchLab.text = "搜索联系人"
        searchLab.textColor = colorWithHexString(hex: "999999")
        searchLab.font = UIFont.systemFont(ofSize: 16)
        searchLab.textAlignment = NSTextAlignment.center
        searchView.addSubview(searchLab)
        self.searchLab = searchLab
        
        self.searchCoverView = YTDrawCoverView(InView: self.view, Frame: CGRect(x: 0, y: searchViewHeight, width: kScreenWidth, height: kScreenHeight-getYTHeight(obj: bgView)), Target: self, Action: #selector(ContactController.coverViewTapGesture))
    }
    func coverViewTapGesture()
    {
        self.searchCoverView?.isHidden = true
        setSearchViewPosition()
    }
    func setSearchViewPosition()
    {
        let w = kScreenWidth*0.7
        let centerX = kScreenWidth*0.5
        if getYTWidth(obj: self.textField!) == w {//编辑状态 --> 初始状态
            self.searchCoverView?.isHidden = true
            self.searchLab?.isHidden = false
            self.textField?.placeholder = ""
            self.textField?.resignFirstResponder()
            setYTRight(obj: self.searchImg!, right: centerX-35)
            setYTLeft(obj: self.textField!, left: getYTRight(obj: self.searchImg!)+6)
            setYTLeft(obj: self.searchLab!, left: getYTRight(obj: self.searchImg!)+6)
            setYTWidth(obj: self.textField!, width: centerX)
        }else{//初始状态--> 编辑状态
            self.searchCoverView?.isHidden = false
            self.searchLab?.isHidden = true
            self.textField?.placeholder = self.searchLab?.text
            setYTLeft(obj: self.searchImg!, left: 24)
            setYTLeft(obj: self.searchLab!, left: getYTRight(obj: self.searchImg!)+6)
            setYTLeft(obj: self.textField!, left: getYTRight(obj: self.searchImg!)+6)
            setYTWidth(obj: self.textField!, width: w)
        }
    }
    
    func initSubviews()
    {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.separatorColor = MainColor
        tableView.register(UINib(nibName: self.cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: self.cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = ClearColor
        self.view.addSubview(tableView)
        self.tableView = tableView;
        
        tableView.mas_makeConstraints({ (make) in
            make?.top.equalTo()(self.view)?.setOffset(searchViewHeight)
            make?.bottom.equalTo()(self.view)?.setOffset(0)
            make?.left.equalTo()(self.view)?.setOffset(0)
            make?.right.equalTo()(self.view)?.setOffset(0)
        })
        
        self.dataSource = NSMutableArray()
        self.localDataSource = NSMutableArray()
    }
    
    //MARK: - Action method
    func addAction()
    {
        if !dataCenter.isAlreadyLogin() {
            appDelegate.loadLoginVC()
            return
        }
        let navi = YTNavigationController(rootViewController: NewContactController())
        navi.initNavigationBar()
        self.present(navi, animated: false, completion: nil)
    }
    func callAction(phone: String) {
        
        application.open(URL(string: "tel:\(phone)")!, options: [:], completionHandler: nil)
    }
    
    //MARK:- UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource?.count != 0 {
            return (self.dataSource?.count)!
        }else{
            return (self.localDataSource?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {       
        if dataSource?.count != 0 {
            let data = self.dataSource?.object(at: section) as! ContactData
            return data.name
        }else{
            let arr = self.localDataSource?.object(at: section) as! DepartmentData
            return arr.name
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UITableViewHeaderFooterView.init(reuseIdentifier: headerIdentifier)
        let view = UIView(frame:headView.bounds)
        headView.addSubview(view)
        return headView
    }
    //设置区脚背景色
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = ClearColor
    }
    //设置区头背景色
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = UIColor(patternImage: UIImage(named: "navi_bg-2")!)
        header.layer.borderColor = MainColor.cgColor
        header.layer.borderWidth = 0.5
        header.textLabel?.textColor = WhiteColor
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ContactSectionHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.dataSource?.count != 0 {
            if section == (self.dataSource?.count)!-1 {
                return 49
            }
        }
        return 0
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ContactCellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource?.count == 0
        {
            return (self.localDataSource?.object(at: section) as! DepartmentData).list!.count
        }else{
            return ((self.dataSource?.object(at: section) as! ContactData).member?.count)!
        }
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! AdressListCell
        var data:UserData
        if self.dataSource?.count == 0 {
            data = (self.localDataSource?.object(at: indexPath.section) as! DepartmentData).list!.object(at: indexPath.row) as! UserData
        }else{
            data = (self.dataSource?.object(at: indexPath.section) as! ContactData).member?.object(at: indexPath.row) as! UserData
        }
        cell.backgroundColor = ClearColor
        cell.setContent(data: data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ContactDetailController()
        controller.hidesBottomBarWhenPushed = true
        var data:UserData
        if self.dataSource?.count == 0 {
            data = (self.localDataSource?.object(at: indexPath.section) as! DepartmentData).list!.object(at: indexPath.row) as! UserData
        }else{
            data = (self.dataSource?.object(at: indexPath.section) as! ContactData).member?.object(at: indexPath.row) as! UserData
        }
        controller.userData = data
        self.navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: indexPath) as! AdressListCell
        weak var weakSelf = self
        let callAction = UITableViewRowAction(style: .normal, title: "拨打") { (action:UITableViewRowAction, indexPath:IndexPath) in
            weakSelf?.callAction(phone: cell.phone!)
        }
        callAction.backgroundColor = MainColor
        return [callAction]
    }
    
    //MARK: -UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { 
            self.setSearchViewPosition()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.setSearchViewPosition()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: -ContactModelDelegate
    func requestContactListSucc(result: ContactRestultData) {
        self.messageView?.hideMessage()
        self.tableView?.stopLoading()
        if result.total == 0 {
        }else{
            //将列表存入coredata，记得卸载程序，抹掉假数据。
            self.dataSource = result.data
            self.tableView?.reloadData()
        }
        //将数据保存到本地
        addCoreDataFromArray(ModelList: result.data!)
    }
    func requestContactListFail(error: ErrorData) {
        self.messageView?.hideMessage()
        self.tableView?.stopLoading()
        self.messageView?.setMessage(Message: error.message!, Duration: 1)
        if error.code == kNetworkErrorCode {//网络连接问题，加载本地数据
            self.dataSource?.removeAllObjects()
            self.localDataSource = getDataFromCoreData()
            self.tableView?.reloadData()
        }
        
    }
}
