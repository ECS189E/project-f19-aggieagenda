//
//  classes.swift
//  MyCalendar
//
//  Created by Yan Yubing on 11/30/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//
import Foundation

class event {
    var title:String
    
    init(_ dataString: String){
        title = dataString
    }
}

class User {
    static var user = [(key: Date, value: [event])] ()
}


