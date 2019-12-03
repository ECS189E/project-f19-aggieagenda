//
//  EventTableViewCell.swift
//  MyCalendar
//
//  Created by Yan Yubing on 12/3/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var eventCell: UIView!
    
    @IBOutlet weak var EventTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        eventCell.backgroundColor = UIColor(red: 99/255, green: 42/255, blue: 80/255, alpha: 1)
        eventCell.layer.shadowOffset = CGSize(width: 3, height: 3)
        eventCell.layer.shadowOpacity = 0.25
        eventCell.layer.cornerRadius = 20
        eventCell.layer.shadowColor = UIColor.red.cgColor
        eventCell.layer.masksToBounds = false
        eventCell.layer.shadowRadius = 10
        eventCell.layer.shadowOffset = CGSize(width:4,height:10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    func setCell(title:String){
        EventTitle.text = title
    }
}
