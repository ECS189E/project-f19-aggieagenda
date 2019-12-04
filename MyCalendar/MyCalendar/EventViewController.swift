//
//  EventViewController.swift
//  MyCalendar
//
//  Created by Jatuh on 12/3/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var event:event?

    override func viewDidLoad() {
        print(event?.title)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}
