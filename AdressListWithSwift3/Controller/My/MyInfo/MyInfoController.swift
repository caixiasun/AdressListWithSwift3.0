//
//  MyInfoController.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/22.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class MyInfoController: UIViewController,MyModelDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var myModel = MyModel()
    var uploadAlertController:UIAlertController!
    var imagePickerController:UIImagePickerController!
    var messageView:MessageView?
    @IBOutlet weak var headImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSubviews()
        self.initAlertController()
        self.initImagePickerController()
    }
    func initSubviews()
    {
        self.view.backgroundColor = PageGrayColor
        self.navigationItem.title = "个人信息"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.tintColor = WhiteColor
        
        self.messageView = addMessageView(InView: self.view)
        self.myModel.delegate = self
    }
    func initAlertController()
    {
        weak var blockSelf = self
        self.uploadAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        self.uploadAlertController.view.tintColor = DeepMainColor
        let takePhoto = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            blockSelf?.actionAction(action: action)
        }
        let photoLib = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            blockSelf?.actionAction(action: action)
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (action:UIAlertAction) in
            blockSelf?.actionAction(action: action)
        }
        self.uploadAlertController?.addAction(takePhoto)
        self.uploadAlertController?.addAction(photoLib)
        self.uploadAlertController?.addAction(cancel)
    }
    func initImagePickerController()
    {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        // 设置是否可以管理已经存在的图片或者视频
        self.imagePickerController.allowsEditing = true
    }
    func actionAction(action:UIAlertAction)
    {
        if action.title == "拍照" {
            self.getImageFromPhotoLib(type: .camera)
        }else if action.title == "从相册选择" || action.title == "更换头像" {
            self.getImageFromPhotoLib(type: .photoLibrary)
        }else if action.title == "删除照片" {
            self.headImg.image = UIImage(named: "head")
        }
    }
    func getImageFromPhotoLib(type:UIImagePickerControllerSourceType)
    {
        self.imagePickerController.sourceType = type
        //判断是否支持相册
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let type:String = (info[UIImagePickerControllerMediaType] as! String)
        //当选择的类型是图片
        if type == "public.image"
        {
            let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.headImg.image = cropToBounds(image: img!)
            
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("head.jpg")
            let imgData = UIImageJPEGRepresentation(self.headImg.image!, 0.5)
            do {
                try imgData?.write(to: URL.init(fileURLWithPath: path))
                print("图片保存成功！")
            }catch{
                print("图片保存失败！")
            }
            let newPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appending("/head.jpg")
            do{
                let newData = try Data.init(contentsOf: URL(fileURLWithPath: newPath))
                self.messageView?.setMessageLoading()
                self.myModel.requestUploadHeadImg(data: newData)
                
            }catch{
                
            }
            
            
            
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //tapGesture
    
    @IBAction func telTapGesture(_ sender: AnyObject) {
        
    }
    
    @IBAction func headImgTapGesture(_ sender: AnyObject) {
        present(self.uploadAlertController, animated: true, completion: nil)
    }
    
    //MARK: -ContactModelDelegate
    func requestUploadHeadImgSucc(success: SuccessData) {
        self.messageView?.hideMessage()
    }
    func requestUploadHeadImgFail(error: ErrorData) {
        self.messageView?.hideMessage()
    }

}
