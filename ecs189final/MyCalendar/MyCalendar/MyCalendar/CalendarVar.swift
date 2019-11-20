//
//  CalendarVar.swift
//  MyCalendar
//
//  Created by Arthur on 11/17/19.
//  Copyright © 2019 ucdavis.189. All rights reserved.
//

import Foundation


let date =  Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
