//
//  Api.swift
//  MyCalendar
//
//  Created by Yan Yubing on 11/30/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//


import Foundation

class Api{
    
    var jsondata: [[String:Any]]
    
    init(){
        self.jsondata = [["":""]]
    }
    
    func ApiCall(user:User, completionHandler: @escaping (_ Response: String?, _ Error: String?)->Void){
        let headers = [
            "Authorization": "Bearer 3438~uiAiZbeRqNRGiAAR8qzKhsUAl6wjnCOO1B0yLiARM5pbm6vLuVCl7nppz6V4baRv",
            "User-Agent": "PostmanRuntime/7.20.1",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "0c99bf33-6c24-467e-a80d-599f718864f0,d30935e3-83de-43af-bba0-7960c627a8f8",
            "Host": "canvas.ucdavis.edu",
            "Accept-Encoding": "gzip, deflate",
            "Cookie": "log_session_id=5b509230494b9e8ee697d3852bc2c86d; canvas_session=_I3Ll6aVrphgzBt525zS2w.QeWZCKZoyVoAPkRoONFZt-z0Wou3re-0BvvcEGs5yCLM-wHtwuUSzm-qlckFvrP3inqtjb9Hc8pV9TjvmTLfeKkVsvBlSAH5MAcvlyA-qC_1KzwCUK7zMSZuNxLumZJe.GnGcsTPV_N-YSXiT8nVTI6aHTSs.XeIpow; _csrf_token=kzyW5pH38kGxS0QiBEEcUCWVkAfUes9olRRnVR0jE5Twdf2NxIWzBoQvNmpiBGU7Z%2FTIf5ozqh32VS1mfnlY3g%3D%3D",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://canvas.ucdavis.edu/api/v1/users/self/upcoming_events")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("herr")
                print(error)
            } else {
                do{
                if let dataResponse = data {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                                  dataResponse, options: [])
                    guard let jsonArray = jsonResponse as? [[String: Any]] else {
                        DispatchQueue.main.async{
                            completionHandler(nil, "error")
                        }
                          return
                    }
                    self.jsondata = jsonArray
                    DispatchQueue.main.async {
                        completionHandler("complete", nil)
                    }
                    /*for dic in self.jsondata{
                        guard let title = dic["title"] as? String else { return }
                        guard let date = dic["all_day_date"] as? String else { return }
                        print(title + " " + date) //Output
//                        print(date)
                    }*/
                    }}catch{
                        print("no")
                }
            }
        })
        
        dataTask.resume()
    }
    
    
}
