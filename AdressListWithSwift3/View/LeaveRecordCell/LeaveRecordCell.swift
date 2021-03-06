//
//  LeaveRecordCell.swift
//  AdressListWithSwift3
//
//  Created by caixiasun on 16/9/21.
//  Copyright © 2016年 yatou. All rights reserved.
//

import UIKit

class LeaveRecordCell: UITableViewCell {

    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var reasonLab: UILabel!
    @IBOutlet weak var endLab: UILabel!
    @IBOutlet weak var startLab: UILabel!
    
    var delegate:LeaveRecordCellDelegate?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCornerRadius(view: self, radius: 10)
        self.layer.borderColor = MainColor.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func setContent(data:LeaveListData)
    {
        self.nameLab.text = data.name
        self.startLab.text = data.started
        self.endLab.text = data.ended
        self.reasonLab.text = data.reason
        
//        self.deleteImg.isHidden = data.status == 1 ?false:true
    }

    
    
    @IBAction func deleteAction(_ sender: AnyObject) {
        if (self.delegate != nil) {
            self.delegate?.deleteRecord!(indexPath: self.indexPath!)
        }
    }
    
    
    
}

@objc protocol LeaveRecordCellDelegate {
    @objc optional func deleteRecord(indexPath:IndexPath)
}
