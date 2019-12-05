//
//  classes.swift
//  MyCalendar
//
//  Created by Yan Yubing on 11/30/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//
import Foundation
import Firebase

class event {
    var title:String
    var isCanvasevent: Bool
    var date:String
    var discription:String
    var isDone:Bool
    var subject:String
    var memo:String
    
    init(_ dataString: String, _ dateString: String, _ isCanvas: Bool, _ course: String){
        title = dataString
        isCanvasevent = isCanvas
        date = dateString
        discription = ""
        isDone = false
        subject = course
        memo = ""
    }
}

class User {
    var user = [(key: Date, value: [event])] ()
    var id: String? = nil
    var username: String? = nil
    var token:String? = nil
    var isfromCanvas:Bool? = nil
    
    func getid(isCanvas: Bool, email: String, token: String, canvasapi: Api, completionHandler: @escaping (_ Response: String?, _ Error: String?)->Void){
        if(!isCanvas){
            self.id = email
            self.token = ""
            self.isfromCanvas = false
            completionHandler("response", nil)
        }else{
            canvasapi.getUserinformation(token:token){
                response, error in
                if(response != nil){
                    self.id = email
                    self.token = token
                    self.username = canvasapi.username
                    self.isfromCanvas = true
                    print("check")
                    DispatchQueue.main.async{
                        completionHandler("response", nil)
                    }
                }
                if(error != nil){
                    self.isfromCanvas = false
                    self.id = email
                    self.token = ""
                    print(self.id)
                    DispatchQueue.main.async{
                        completionHandler("response", nil)
                    }
                }
            }
        }
    }
    
    
    func getdata(db: Firestore, dates: Array<AnyObject>, completionHandler: @escaping (_ Response: String?, _ Error: String?)->Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var temp = [(key: Date, value: [event])] ()
        guard let dname = self.id else{
            DispatchQueue.main.async{
                completionHandler(nil, "error")
            }
            return
        }
        //maybe use a dispatch queue group for optimizing here
        for (index, i) in dates.enumerated(){
            let date = String(_cocoaString: i)
            guard let formatdate = dateFormatter.date(from: date) else {
                DispatchQueue.main.async{
                    completionHandler(nil, "error")
                }
                return}
            var tempevents = [event]()
            let userref = db.collection("users").document(dname).collection(date)
            userref.getDocuments{(document, error) in
                if let document = document, !document.isEmpty{
                    for j in document.documents{
                        let iscanvas = (j.data()["isCanvas"] as? Bool) ?? false
                        let subject = (j.data()["Subject"] as? String) ?? ""
                        // need modify
                        let tempevent = event.init(j.documentID, date, iscanvas, subject)
                        tempevents.append(tempevent)
                    }
                    temp.append((key: formatdate, value: tempevents))
                    self.user = temp
                }
                if index == dates.count - 1 {
                    DispatchQueue.main.async{
                        completionHandler("response", nil)
                    }
                }
            }
        
        }
        
    }
}

