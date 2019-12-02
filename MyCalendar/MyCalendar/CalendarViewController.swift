//
//  CalendarViewController.swift
//  MyCalendar
//
//  Created by Yan Yubing on 11/20/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var canvasdataapi = Api.init()
    var jsondata:[[String:Any]] = [["":""]]
    var email:String = ""
//    var user = User()
    var count:Int = 0
    var activities = [(key: Date, value: [String])] ()
    let dateFormatter = DateFormatter()
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var AddButton: UIButton!
    
    
    func sortdata() {
        var temp = [Date:[String]] ()
        var check:Bool = false
        for dic in self.jsondata{
            check = false
            var temptitles:[String] = []
            guard let date = dic["all_day_date"] as? String else { return }
            guard let title = dic["title"] as? String else { return }
            guard let formatdate = dateFormatter.date(from: date) else {return}
            for i in temp{
                if i.key == formatdate{
                    temptitles = i.value
                    temptitles.append(title)
                    temp.updateValue(temptitles, forKey: formatdate)
                    User.user.updateValue(temptitles, forKey: formatdate)
                    check = true
                }
            }
            if !check{
                temptitles.append(title)
                temp.updateValue(temptitles, forKey: formatdate)
                User.user.updateValue(temptitles, forKey: formatdate)
            }
        }
        self.activities = temp.sorted{$0.key < $1.key}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeStyle = .none
        self.tableview.delegate = self
        self.tableview.dataSource = self
        canvasdataapi.ApiCall(user: User.user){
            response, error in
            if(response != nil){
                self.jsondata = self.canvasdataapi.jsondata
                self.sortdata()
                self.count = self.jsondata.count
                self.tableview.reloadData()
            }
        }
        AddButton.SetAddButtonUI()
        // Do any additional setup after loading the view.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        self.activities = User.user.sorted{$0.key < $1.key}
        print(activities)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Amountcell") ?? UITableViewCell(style: .default, reuseIdentifier: "Amountcell")
        
        let title = self.activities[indexPath.section].value[indexPath.row]
        print(title)
        cell.textLabel?.text = "\(title)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addEventSegue"{
            let vc = segue.destination as! PopupAddEventViewController
            vc.activities = activities
            vc.doneSaving = { [weak self] in
                DispatchQueue.main.async{
                    self?.tableview.reloadData()
                }
            }
        }
    }
}
