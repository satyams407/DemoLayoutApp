//
//  ViewController.swift
//  DemoLayoutApp
//
//  Created by Satyam Sehgal on 02/02/18.
//  Copyright © 2018 Satyam Sehgal. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    //strings declarations
    let okay : String = "Ok"
    let touchIdNotAvailable: String = "Touch ID not available or Not Configured"
    let errorMsg :String = "put here an error msg"
    let authFailed : String = "AuthenticationFailed"
    let unauthorizedUser : String = "Not a Authorised User"
    let touchIdLogin : String = "Please use touch Id to Login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func touchIdButton(_ sender: Any) {
        self.authenticationUsingTouchID()
    }
    
    func authenticationUsingTouchID(){
        let authContext = LAContext()
        var authError : NSError?
        
        if(authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)){
            
            //touch Id is available on the device
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: self.touchIdLogin, reply: {(success, error) -> Void in
                if success {
                
                    // push to new ViewController (WelcomePage)
                    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                    let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    let randomQueue = DispatchQueue(label: "q1", qos : .userInteractive)
                   
                     randomQueue.async {
                        print("in dealock 1")
                        randomQueue.sync {
                             print("in dealock 2")
                        self.navigationController?.pushViewController(objSomeViewController, animated: true)
                      }
                    }
//                    DispatchQueue.main.async {
//                       self.navigationController?.pushViewController(objSomeViewController, animated: true)
//                   }
                }
                else{
                    self.notifyUser(self.authFailed, err: self.unauthorizedUser)
                }
             })
        }else{
            
            //touchID not available
            self.notifyUser(self.touchIdNotAvailable, err: self.errorMsg)
        }
    }
    
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: okay, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

