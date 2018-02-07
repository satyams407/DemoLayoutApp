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
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
   
    @IBAction func touchIdButton(_ sender: Any) {
        authenticationUsingTouchID()
        print("in touch id button function")
    }
    
    func authenticationUsingTouchID(){
        let authContext = LAContext()
        var authError : NSError?
        
        if(authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)){
            //touch Id is available in the device
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "please use touch ID to login", reply: {(success, error) -> Void in
                if success {
                    print("succesfully logged in")
                    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    // If you want to push to new ViewController then use this
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(objSomeViewController, animated: true)
                    }
                    print("sdhajk")
                }
            else{
                print("not a authorised user")
            }
          })
        }else{
            //touchID not available
            let alert = UIAlertController(title: "touch ID not available", message: "error msg", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true,
                         completion: nil)
            print(authError!.localizedDescription)
        }
    }
    
}

