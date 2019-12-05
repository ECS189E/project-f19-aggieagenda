//
//  PopuoAddEventViewController.swift
//  MyCalendar
//
//  Created by Yan Yubing on 12/2/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit
import Firebase
protocol MyProtocol: class
{
    func senduserdataToPreviousVC(newuser:User, completionHandler: @escaping (_ Response: String?, _ Error: String?)->Void)
}

class PopupAddEventViewController: UIViewController {

    
    @IBOutlet weak var EventTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var AddEventButton: UIButton!
    @IBOutlet weak var CancelEventButton: UIButton!
    
    let dateFormatter = DateFormatter()
    var db:Firestore? = nil
    var user:User? = nil
    var doneSaving: (() -> ())?
    var activities = [(key: Date, value: [event])] ()
    var datestrings:[String] = []
    var tempactivities = [(key: Date, value: [event])] ()
    weak var mDelegate:MyProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        let userref = self.db?.collection("users").document(user?.id ?? "")
        userref?.getDocument{(document, error) in
            if let document = document, document.exists{
                print(document.documentID)
                let temp = (document.data()?["dates"] as? NSArray) as Array?
                guard let dates = temp else{
                    return
                }
                for i in dates{
                    let date = String(_cocoaString: i)
                    self.datestrings.append(date)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func addData(completionHandler: @escaping (_ Response: String?, _ Error: String?)->Void) {
        var check:Bool = false
        var tempevents:[event] = []
        let date = datePicker.date
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        guard let title = EventTitle.text else { return }
        for data in activities{
            let newdateString = dateFormatter.string(from: data.key)
            if newdateString == dateString{
               /* tempevents = data.value
                let tempevent = event.init(title, dateString, false)
                tempevents.append(tempevent)
                activities[index].value = tempevents*/
                self.db?.collection("users").document(user?.id ?? "").collection(dateString).document(title).setData(["isCanvas":false]){
                    err in
                        if err != nil{
                            print("there is some error")
                        }else{
                            print("successfully written")
                    }
                }
                //User.user.updateValue(tempevents, forKey: date)
                check = true
            }
        }
        if !check{
            let tempevent = event.init(title, dateString, false, "")
            tempevents.append(tempevent)
            datestrings.append(dateString)
            self.db?.collection("users").document(self.user?.id ?? "").setData(["dates":datestrings]){
                err in
                    if err != nil{
                        print("there is some error")
                    }else{
                        print("successfully written")
                    }
                self.db?.collection("users").document(self.user?.id ?? "").collection(dateString).document(title).setData(["isCanvas":false, "Subject":""]){
                        err in
                            if err != nil{
                                print("there is some error")
                            }else{
                                print("successfully written")
                            }
                        DispatchQueue.main.async{
                            completionHandler("response", nil)
                        }
                    }
                        
                }
                
            //activities.append((key: date, value: tempevents))
           // User.user.updateValue(tempevents, forKey: date)
        }else{
            DispatchQueue.main.async{
                completionHandler("response", nil)
            }
        }
        //need fixing!
      //  user.user = activities
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        if let doneSaving = doneSaving {
            doneSaving()
            self.addData(){response, error in
                if response != nil{
                    guard let db = self.db else{
                        return
                    }
                    guard let newuser = self.user else{
                        return
                    }
                    newuser.getdata(db: db, dates: self.datestrings as Array<AnyObject>){
                        response, error in
                        if response != nil{
                            self.mDelegate?.senduserdataToPreviousVC(newuser:newuser){
                                response, error in
                                if response != nil{
                                    self.dismiss(animated:true)
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
    }
    
   
    @IBAction func cancelEvent(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
