//
//  ViewController.swift
//  MyCalendar
//
//  Created by Arthur on 11/17/19.
//  Copyright © 2019 ucdavis.189. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var Calendar: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "Auguest", "September", "October" ,"November", "December"]
    let DaysOfMonth = ["Monday", "Tuesday" ,"Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var DaysInMonth = [31,28,31,30,31,30,31,31,31,31,30,31]
    var currentMonth = String()
    var NumberOfEmptyBox = Int()//the number of empty boxes at the start of the current month
    var NextNumberOfEmptyBox = Int()// the same with above but with the next month
    var PreviousNumberOfEmptyBox = 0//the same with above but with the previous month
    var Direction = 0// = 0 if we are at the current month, 1 if we are in future month, -1 if in past month
    var PositionIndex = 0 // store the above vars of the empty boxes
    var LeapyearCounter = 3// next leap year is in 1 year
    
    
    
    
    
    @IBAction func NextButton(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            Direction = 1
            
            
            if LeapyearCounter < 5 {
                LeapyearCounter += 1
            }
            
            if LeapyearCounter == 4{
                DaysInMonth[1] = 29
                
            }
            
            if LeapyearCounter == 5{
                LeapyearCounter = 1
                DaysInMonth[1] = 28
            }
            
            
            GetsStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        default:
            
            Direction = 1
            GetsStartDateDayPosition()
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    @IBAction func BackButton(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            
            
            if LeapyearCounter > 0{
                LeapyearCounter -= 1
            }
            
            if LeapyearCounter == 0{
                DaysInMonth[1] = 29
                LeapyearCounter = 4
            }else{
                DaysInMonth[1] = 28
            }
            
            
            GetsStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            month -= 1
            Direction = -1
            GetsStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonth =  Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
    }
    
    
    
    
    //this function gave us the number of empt boxes
    func GetsStartDateDayPosition(){
        switch Direction{
        case 0://if in current month
            switch day{
            case 1...7:
                NumberOfEmptyBox = weekday - day
            case 8...14:
                NumberOfEmptyBox =  weekday - day - 7
            case 15...14:
                NumberOfEmptyBox =  weekday - day - 14
            case 15...21:
                NumberOfEmptyBox =  weekday - day - 21
            case 22...28:
                NumberOfEmptyBox =  weekday - day - 28
            default:
                break
            }
            
            PositionIndex = NumberOfEmptyBox
            
        case 1...:// if in future month
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonth[month])%7
            PositionIndex = NextNumberOfEmptyBox
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonth[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex =  PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{//return the nubmer of days in the month + the number of empty boexes on the going direction
        case 0:
            return DaysInMonth[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonth[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonth[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.DateLabel.textColor = UIColor.black
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        
        switch Direction{
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        if Int(cell.DateLabel.text!)! < 1{
                   cell.isHidden = true
                   
               }
        //show the weekend days in differnt color
         switch indexPath.row{
         case 5,6,12,13,19,20,26,27,33,34: // the indexs of the collection view matches with the weekend days in every month
            if Int(cell.DateLabel.text!)! > 0{
            cell.DateLabel.textColor = UIColor.green
         }
         default:
            break
         }
        
        //mark red when shows the current date
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
            cell.backgroundColor = UIColor.red
        }
        return cell
    }
    
 
    
}

