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
    var activities = [(key: Date, value: [event])] ()
    var tempactivities = [(key: Date, value: [event])] ()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addData() {
       // var temp = [Date:[event]] ()
        var check:Bool = false
        var tempevents:[event] = []

        let date = datePicker.date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        guard let title = EventTitle.text else { return }
        for (index, data) in activities.enumerated(){
            let newdateString = dateFormatter.string(from: data.key)
            if newdateString == dateString{
                tempevents = data.value
                let tempevent = event.init(title)
                tempevents.append(tempevent)
                activities[index].value = tempevents
                //User.user.updateValue(tempevents, forKey: date)
                check = true
            }
        }
        if !check{
            let tempevent = event.init(title)
            tempevents.append(tempevent)
            activities.append((key: date, value: tempevents))
           // User.user.updateValue(tempevents, forKey: date)
        }
        User.user = activities
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
