//
//  PopuoAddEventViewController.swift
//  MyCalendar
//
//  Created by Yan Yubing on 12/2/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit

class PopupAddEventViewController: UIViewController {

    
    @IBOutlet weak var EventTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var AddEventButton: UIButton!
    @IBOutlet weak var CancelEventButton: UIButton!
    
    var doneSaving: (() -> ())?
    var activities = [(key: Date, value: [String])] ()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addData() {
        var temp = [Date:[String]] ()
        var check:Bool = false
        var temptitles:[String] = []
        let date = datePicker.date
        guard let title = EventTitle.text else { return }
        
        for i in temp{
            if i.key == date{
                temptitles = i.value
                temptitles.append(title)
                temp.updateValue(temptitles, forKey: date)
                User.user.updateValue(temptitles, forKey: date)
                check = true
            }
        }
        if !check{
            temptitles.append(title)
            temp.updateValue(temptitles, forKey: date)
            User.user.updateValue(temptitles, forKey: date)
        }
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        if let doneSaving = doneSaving {
            doneSaving()
            self.addData()
        }
        dismiss(animated: true)
    }
    
   
    @IBAction func cancelEvent(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
