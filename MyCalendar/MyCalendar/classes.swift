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
    var isCanvasevent: Bool
    
    init(_ dataString: String){
        title = dataString
        isCanvasevent = false
    }
}

class User {
    static var user = [(key: Date, value: [event])] ()
}


