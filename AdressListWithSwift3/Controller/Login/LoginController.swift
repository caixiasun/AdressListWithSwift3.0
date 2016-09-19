//
//  LoginController.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/19.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class LoginController: UIViewController ,UserModelDelegate{
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var telTextField: UITextField!//tag=1
    @IBOutlet weak var psdTextField: UITextField!//tag=2
    
    var messageView:MessageView?
    let userModel:UserModel? = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubviews()
        
        self.initNaviBar()
        
        self.userModel?.delegate = self
    }
    
    func initSubviews()
    {
        setBorder(view: self.loginBtn)
        setCornerRadius(view: self.loginBtn, radius: 10)
        
        self.messageView = addMessageView(InView: self.view)
    }
    
    func initNaviBar()
    {
        self.navigationItem.title = "登录"
        
        let cancelBtn = YTDrawButton(title: kTitle_cancel_button, TitleColor: WhiteColor, FontSize: kFontSize_navigationBar_button, Target: self, Action: #selector(itemAction(_:)))
        cancelBtn.tag = 1
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
    }
    
    
    
    @IBAction func itemAction(_ sender: UIButton) {
        switch sender.tag {
        case 1://cancel
            exitThisController()
            break
        default://登录
            loginAction()
            break
        }

    }
    func loginAction()
    {
        if (telTextField.text?.isEmpty)! {
            self.messageView?.setMessage(Message: "手机号不能为空！", Duration: 1)
            return
        }
        if (psdTextField.text?.isEmpty)! {
            self.messageView?.setMessage(Message: "密码不能为空！", Duration: 1)
            return
        }
        
        self.messageView?.setMessageLoading()
        let params = [kMobile:self.telTextField.text!,kPassword:self.psdTextField.text!] as [String : Any]
        self.userModel?.loginRequest(Params: params)
    }
    func exitThisController()
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -UserModelDelegate
    func loginSucc(userData: UserData) {
        self.messageView?.hideMessage()
        self.messageView?.setMessage(Message: "登录成功", Duration: 1)
        dataCenter.setLogin()
        dataCenter.saveUserData(Data: userData)
        perform(#selector(exitThisController), with: nil, afterDelay: 1.5)
        
    }
    func loginFail(error: ErrorData) {
        self.messageView?.hideMessage()
        self.messageView?.setMessage(Message: error.message!, Duration: 1)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}