//
//  CalendarViewController.swift
//  MyCalendar
//
//  Created by Yan Yubing on 11/20/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    var email:String = ""
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Api.ApiCall(user: user)
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

}
