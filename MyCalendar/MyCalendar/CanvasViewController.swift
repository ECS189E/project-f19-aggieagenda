//
//  CanvasViewController.swift
//  MyCalendar
//
//  Created by Arthur on 12/4/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit
import SafariServices

class CanvasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBAction func CanvasURL(_ sender: Any) {
        showSafariVC(for: "https://canvas.ucdavis.edu/")
    }
    let steps = ["step1","step2","step3","step4"]
    
    func showSafariVC(for url: String){
        guard let url = URL(string: url)else{
            return
        }
        
        let safariVC =  SFSafariViewController(url: url)
        present(safariVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(steps.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CanvasTableViewCell
        cell.myImage.image = UIImage(named: (steps[indexPath.row] + ".png"))
        cell.myLabel.text = steps[indexPath.row]
        return (cell)
    }
    
    var canvasdataapi = Api.init()
       var jsondata:[[String:Any]] = [["":""]]
       var email:String! = ""
    var password:String! = ""
    var token:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var TokenLabel: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        let token = "Bearer " + TokenLabel.text!
     
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let calendarVC = storyboard.instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
        calendarVC.token = token
            self.present(calendarVC, animated: true, completion: nil)
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
