//
//  ViewController.swift zuixinban
//  MyCalendar
//
//  Created by Yan Yubing on 11/20/19.
//  Copyright © 2019 Yan Yubing. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var SignSelector: UISegmentedControl!
    @IBOutlet weak var EmailEntered: UITextField!
    @IBOutlet weak var PasswordEntered: UITextField!
    @IBOutlet weak var SignButton: UIButton!
    
    @IBOutlet weak var Success: UILabel!
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignSelect(_ sender: Any) {
        isSignIn = !isSignIn
        
        if isSignIn {
            SignButton.setTitle("Sign In", for: .normal)
        }else{
            SignButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func ButtonPress(_ sender: Any) {
        
        if let email = EmailEntered.text, let password = PasswordEntered.text{
            if isSignIn {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let calendarVC = storyboard.instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
                        calendarVC.email = email
                        self.present(calendarVC, animated: true, completion: nil)
                    }else{
                        self.Success.text = "Unmatch Email & Password"
                    }
                })
            }else{
               Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if user != nil{
                    print("here")
                        
                    }else{
                        print("uh")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let canvasVC = storyboard.instantiateViewController(identifier: "Canvas") as! CanvasViewController
                    canvasVC.email = email
                    self.present(canvasVC, animated: true, completion: nil)

                    }
                })
            }
        }else{
            self.Success.text = "Enter your Email and Password"
        }
        
       
    }
}

