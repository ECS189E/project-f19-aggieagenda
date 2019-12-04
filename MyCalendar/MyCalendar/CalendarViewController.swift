//
//  CalendarViewController.swift
//  MyCalendar
//
//  Created by Yan Yubing on 11/20/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var canvasdataapi = Api.init()
    var ref: DocumentReference? = nil
    var jsondata:[[String:Any]] = [["":""]]
    var email:String = ""
//    var user = User()
    var count:Int = 0
    var id:Int = 0
    var name:String = ""
    var token:String = "Bearer 3438~uiAiZbeRqNRGiAAR8qzKhsUAl6wjnCOO1B0yLiARM5pbm6vLuVCl7nppz6V4baRv"
    var activities = [(key: Date, value: [event])] ()
    var selectdateindex:Int = 0
    var selecteventindex:Int = 0
    let dateFormatter = DateFormatter()
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var AddButton: UIButton!
    
    
    func initializeCanvasevents() {
        var temp = [Date:[event]] ()
        var check:Bool = false
        for dic in self.jsondata{
            check = false
            var temptitles:[event] = []
            guard let date = dic["all_day_date"] as? String else { return }
            guard let title = dic["title"] as? String else { return }
            let tempevent = event.init(title)
            guard let formatdate = dateFormatter.date(from: date) else {return}
            for i in temp{
                if i.key == formatdate{
                    temptitles = i.value
                    tempevent.isCanvasevent = true
                    temptitles.append(tempevent)
                    temp.updateValue(temptitles, forKey: formatdate)
                    check = true
                }
            }
            if !check{
                tempevent.isCanvasevent = true
                temptitles.append(tempevent)
                temp.updateValue(temptitles, forKey: formatdate)
            }
        }
        
        self.activities = temp.sorted{$0.key < $1.key}
        User.user = self.activities
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeStyle = .none
        self.tableview.delegate = self
        self.tableview.dataSource = self
        canvasdataapi.ApiCall(token:token){
            response, error in
            if(response != nil){
                self.jsondata = self.canvasdataapi.upcomingeventsdata
                self.initializeCanvasevents()
                self.count = self.jsondata.count
                self.tableview.reloadData()
            }
        }
        canvasdataapi.getUserinformation(token:token){
            response, error in
            if(response != nil){
                self.id = self.canvasdataapi.id
                self.name = self.canvasdataapi.username
                print(self.id)
                print("name: " + self.name)
            }
        }
        AddButton.SetAddButtonUI()
        // Do any additional setup after loading the view.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        self.activities = User.user.sorted{$0.key < $1.key}
        //print(activities)
        return self.activities.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.activities = User.user.sorted{$0.key < $1.key}
        let title = self.activities[section].key
        let titlestring = dateFormatter.string(from:title)
        return "\(titlestring)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.activities = User.user.sorted{$0.key < $1.key}
//        print(self.activities[section].value.count)
        return self.activities[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.activities = User.user.sorted{$0.key < $1.key}
//        print(activities)
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
        
        let title = self.activities[indexPath.section].value[indexPath.row].title
        cell.setCell(title:title)
//        cell.textLabel?.text = "\(title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.activities[indexPath.section].value[indexPath.row].isCanvasevent{
            return false
        }else{
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete"){(contextualAction, view, actionPerformed: @escaping (Bool) -> Void) in
            //delete here
            let alert = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(alertAction) in
                actionPerformed(false)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(alertAction) in
                var temp = self.activities[indexPath.section].value
                 temp.remove(at: indexPath.row)
                 if temp.count != 0{
                     self.activities[indexPath.section].value = temp
                     User.user = self.activities
                     self.tableview.deleteRows(at: [indexPath], with: .fade)
                 }else{
                     self.activities.remove(at: indexPath.section)
                     User.user = self.activities
                    self.tableview.deleteSections([indexPath.section], with: .fade)
                     //self.tableview.reloadData()
                 }
                 
                // self.tableview.reloadData()
                 actionPerformed(true)
            }))
            
            self.present(alert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.index = indexPath.row
        self.selectdateindex = indexPath.section
        self.selecteventindex = indexPath.row
        self.performSegue(withIdentifier: "toEvent", sender: self)
        
        
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //for further instructions
    }*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEventSegue"{
            let vc = segue.destination as! PopupAddEventViewController
            vc.activities = activities
            vc.doneSaving = { [weak self] in
                DispatchQueue.main.async{
                    self?.tableview.reloadData()
                }
            }
        }else if segue.identifier == "toEvent"{
            let VC = segue.destination as! EventViewController
            VC.event = activities[selectdateindex].value[selecteventindex]
        }
    }
}
