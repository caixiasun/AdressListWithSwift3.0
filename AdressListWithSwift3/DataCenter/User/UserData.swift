//
//  UserData.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/19.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class UserData: NSObject,NSCoding {

    var name:String?
    var tel:String?
    var headImg:UIImage?
    var email:String?
    var address:String?
    var birthDay:String?
    var count:Int = 0
    var idNum:Int = 0 //id
    var isLeave:Bool = false //是否请假
    var department:String?//部门
    var position:String?//职位
    var sex:String? //1男 2女
    var nickName:String?
    var token:String?
    var status:Int = 0 //账号状态 0：启用；1：禁用
    
    static func initWithUser(nUser user:User) -> UserData
    {
        let model = UserData()
        model.name = user.name
        model.tel = user.tel
        model.isLeave = user.isLeave
        if user.email != nil && !((user.email?.isEmpty)!) {
            model.email = user.email
        }
        if user.address != nil && !((user.address?.isEmpty)!) {
            model.address = user.address
        }
        if user.birthDay != nil && !((user.birthDay?.isEmpty)!) {
            model.birthDay = user.birthDay
        }
        if (user.headImg != nil) {
            model.headImg = UIImage(data: user.headImg! as Data)
        }
        return model
    }
    //重写MJExtension方法，对应本地属性名和服务器字段名
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "tel":"mobile",
            "idNum":"id",
            "position":"level_name",
            "headImg":"head_img",
            "nickName":"nickname"
        ]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.tel, forKey: "tel")
        aCoder.encode(self.headImg, forKey: "headImg")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.birthDay, forKey: "birthDay")
        aCoder.encode(self.department, forKey: "department")
        aCoder.encode(self.position, forKey: "position")
        aCoder.encode(self.sex, forKey: "sex")
        aCoder.encode(self.nickName, forKey: "nickName")
        aCoder.encode(self.count, forKey: "count")
        aCoder.encode(self.idNum, forKey: "idNum")
        aCoder.encode(self.status, forKey: "status")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.name = aDecoder.decodeObject(forKey: "name") as! String?
        self.tel = aDecoder.decodeObject(forKey: "tel") as! String?
        self.headImg = aDecoder.decodeObject(forKey: "headImg") as! UIImage?
        self.email = aDecoder.decodeObject(forKey: "email") as! String?
        self.address = aDecoder.decodeObject(forKey: "address") as! String?
        self.birthDay = aDecoder.decodeObject(forKey: "birthDay") as! String?
        self.department = aDecoder.decodeObject(forKey: "department") as! String?
        self.position = aDecoder.decodeObject(forKey: "position") as! String?
        self.sex = aDecoder.decodeObject(forKey: "sex") as! String?
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as! String?
        self.count = Int(aDecoder.decodeCInt(forKey: "count"))
        self.idNum = Int(aDecoder.decodeCInt(forKey: "idNum"))
        self.status = Int(aDecoder.decodeCInt(forKey: "status"))
    }
    
    override init() {
        
    }
    
    //返回 数据保存路径
    func getFilePath() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return path.appendingPathComponent("contacts.data")
    }
}