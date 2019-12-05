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

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MyProtocol{
    func senduserdataToPreviousVC(newuser: User, completionHandler: @escaping (String?, String?) -> Void) {
        self.user = newuser
        self.tableview.reloadData()
        DispatchQueue.main.async{
            completionHandler("response", nil)
        }
    }
    
    
    
    let db = Firestore.firestore()
    private let refreshControl = UIRefreshControl()
    var canvasdataapi = Api.init()
    var user = User()
    var ref: DocumentReference? = nil
    var jsondata:[[String:Any]] = [["":""]]
    var email:String = ""
    var id:Int = 0
    var name:String = ""
    var token:String = ""
    var activities = [(key: Date, value: [event])] ()
    var selectdateindex:Int = 0
    var selecteventindex:Int = 0
    let dateFormatter = DateFormatter()
    var isfromCanvas:Bool = false
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var AddButton: UIButton!
    
    @objc private func refreshcalender(_ sender: Any){
        getData()
        self.refreshControl.endRefreshing()
        self.activityIndicatorView.stopAnimating()
    }
    func initializeCanvasevents(completionHandler: @escaping (_ Response: String?, _ Error: String?)->Void) {
        var temp = [Date:[event]] ()
        var check:Bool = false
        let dispatchGroup = DispatchGroup.init()
        let dispatchQueue = DispatchQueue(label: "taskQueue")
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        dispatchQueue.async{
            for dic in self.jsondata{
                //print(dic)
                dispatchGroup.enter()
                check = false
                var temptitles:[event] = []
                guard let date = dic["all_day_date"] as? String else { return }
                guard let title = dic["title"] as? String else { return }
                guard let assignment = dic["assignment"] as? [String:Any] else{
                    return }
                guard let courseid = assignment["course_id"] as? Int else{
                    return
                }
                let courseidstring = String(courseid)
                self.canvasdataapi.getCourse(token: self.token, courseid: courseidstring){
                    response, error in
                    if response != nil{
                        //print(self.canvasdataapi.subject)
                        let tempevent = event.init(title, date, true, self.canvasdataapi.subject)
                        guard let formatdate = self.dateFormatter.date(from: date) else {return}
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
                        self.activities = temp.sorted{$0.key < $1.key}
                        self.user.user = self.activities
                        dispatchSemaphore.signal()
                        dispatchGroup.leave()
                    }
                    if error != nil{
                        print("there is some error!")
                        DispatchQueue.main.async {
                            completionHandler(nil, "error")
                        }
                    }
                }
                dispatchSemaphore.wait()
            }
        }
        dispatchGroup.notify(queue: dispatchQueue){
            DispatchQueue.main.async {
                completionHandler("complete", nil)
            }
            
        }
        
        
    }

    
    func getData(){
        
        let dname = email
        //print(dname)
        let userref = self.db.collection("users").document(dname)
        userref.getDocument{(document, error) in
            if let document = document, document.exists{
                //print(document.documentID)
                let temp = (document.data()?["dates"] as? NSArray) as Array?
                guard let dates = temp else{
                    return
                }
                self.user.token = (document.data()?["token"] as? String ?? "")
                self.token = self.user.token ?? ""
                self.user.getdata(db: self.db, dates: dates){
                    response, error in
                    if response != nil{
                        self.tableview.reloadData()
                    }
                }
            }else{
                if(self.isfromCanvas){
                    self.canvasdataapi.ApiCall(token:self.token){
                                       response, error in
                                       if(response != nil){
                                           self.jsondata = self.canvasdataapi.upcomingeventsdata
                                           self.initializeCanvasevents(){
                                               response, error in
                                               if response != nil{
                                                   self.tableview.reloadData()
                                                   var allstring:[String] = []
                                                   for i in self.activities{
                                                       let tempdatestring = self.dateFormatter.string(from: i.key)
                                                       allstring.append(tempdatestring)
                                                       for j in i.value{
                                                           self.db.collection("users").document(dname).collection(tempdatestring).document(j.title).setData(["isCanvas":j.isCanvasevent, "Subject":j.subject]){
                                                                   err in
                                                                       if err != nil{
                                                                           print("there is some error")
                                                                       }else{
                                                                           print("successfully written")
                                                                   }
                                                               }
                                                       }
                                                    self.db.collection("users").document(dname).setData(["dates":allstring, "token":self.token, "isCanvasUser":true]){
                                                           err in
                                                               if err != nil{
                                                                   print("there is some error")
                                                               }else{
                                                                   print("successfully written")
                                                           }
                                                       }
                                                    
                                                   }
                                               }
                                           }
                                           
                                       }
                                   }
                    
                }else{
                    self.db.collection("users").document(dname).setData(["dates":"", "token":self.token, "isCanvasUser":false]){
                        err in
                            if err != nil{
                                print("there is some error")
                            }else{
                                print("successfully written")
                        }
                    }
                }
                
               
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeStyle = .none
        self.tableview.delegate = self
        self.tableview.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshcalender(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Getting calender data...")
        self.tableview.refreshControl = refreshControl
        user.getid(isCanvas: isfromCanvas, email: email, token: token, canvasapi: canvasdataapi){
            response, error in
            if(response != nil){
                self.getData()
            }
        }
        
       
        AddButton.SetAddButtonUI()
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.activities = user.user.sorted{$0.key < $1.key}
        //print(activities)
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.activities = user.user.sorted{$0.key < $1.key}
        let title = self.activities[section].key
        let titlestring = dateFormatter.string(from:title)
        return "\(titlestring)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.activities = user.user.sorted{$0.key < $1.key}
//        print(self.activities[section].value.count)
        return self.activities[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.activities = user.user.sorted{$0.key < $1.key}
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
                let date = self.dateFormatter.string(from: self.activities[indexPath.section].key)
                let userref = self.db.collection("users").document(self.user.id ?? "").collection(date).document(self.activities[indexPath.section].value[indexPath.row].title)
                userref.delete(){
                    error in
                    if error != nil{
                        print (error as Any)
                    }
                }
                var temp = self.activities[indexPath.section].value
                 temp.remove(at: indexPath.row)
                 if temp.count != 0{
                     self.activities[indexPath.section].value = temp
                    self.user.user = self.activities
                     self.tableview.deleteRows(at: [indexPath], with: .fade)
                 }else{
                    let userref = self.db.collection("users").document(self.user.id ?? "")
                    userref.getDocument{(document, error) in
                        if let document = document, document.exists{
                            print(document.documentID)
                            let temp = (document.data()?["dates"] as? NSArray) as Array?
                            var datestrings:[String] = []
                            guard let dates = temp else{
                                return
                            }
                            for i in dates{
                                let checkdate = String(_cocoaString: i)
                                if checkdate != date{
                                    datestrings.append(checkdate)
                                }
                                
                            }
                            self.db.collection("users").document(self.user.id ?? "").setData(["dates":datestrings]){
                            err in
                                if err != nil{
                                    print("there is some error")
                                }else{
                                    print("successfully written")
                                }
                        }
                    }
                    self.activities.remove(at: indexPath.section)
                    self.user.user = self.activities
                    self.tableview.deleteSections([indexPath.section], with: .fade)
                    
                     //self.tableview.reloadData()
                 }
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
            vc.mDelegate = self
            vc.activities = activities
            vc.db = self.db
            vc.user = self.user
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
