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
    var user = User()
    var count:Int = 0
    var activities = [(key: Date, value: [String])] ()
    let dateFormatter = DateFormatter()
    @IBOutlet weak var tableview: UITableView!
    
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
                    check = true
                }
            }
            if !check{
                temptitles.append(title)
                temp.updateValue(temptitles, forKey: formatdate)
            }
        }
        self.activities = temp.sorted{$0.key < $1.key}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.tableview.delegate = self
        self.tableview.dataSource = self
        canvasdataapi.ApiCall(user: user){
            response, error in
            if(response != nil){
                self.jsondata = self.canvasdataapi.jsondata
                self.sortdata()
                self.count = self.jsondata.count
                self.tableview.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.activities.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.activities[section].key
        let titlestring = dateFormatter.string(from:title)
        return "\(titlestring)"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Amountcell") ?? UITableViewCell(style: .default, reuseIdentifier: "Amountcell")
        let title = self.activities[indexPath.section].value[indexPath.row]
        cell.textLabel?.text = "\(title)"
        return cell
    }
    
}
