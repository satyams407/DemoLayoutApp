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
    }
    
   
    @IBAction func touchIdButton(_ sender: Any) {
        self.enableTouchIdAlert("Would you like to enable Touch Id?",
                                err: "TouchId enables biometric access to mBriefing for all fingerprints enabled on this device")
    }
    
    //strings declarations
    let okay : String = "Ok"
    let touchIdNotAvailable: String = "Touch ID not available or Not Configured"
    let errorMsg :String = "put here an error msg"
    let authFailed : String = "AuthenticationFailed"
    let unauthorizedUser : String = "Not a Authorised User"
    let touchIdLogin : String = "Please use touch Id to Login"
    
    
    
    func authenticationUsingTouchID(){
        let authContext = LAContext()
        var authError : NSError?
        
        if(authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)){
            
           //touch Id is available
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: self.touchIdLogin, reply: {(success, error) -> Void in
                if success {

                    // push to new ViewController (WelcomePage)
                    let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                    let objSomeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(objSomeViewController, animated: true)
                    }
                }
                else{
                    self.notifyUser(self.authFailed, err: self.unauthorizedUser)
                }
            })
        }else{
            
         //touchID not available or not configured
       if #available(iOS 11.0, *) {
                switch authError!.code{

                case LAError.Code.biometryNotEnrolled.rawValue:
                   UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)

                case LAError.Code.passcodeNotSet.rawValue:
                    self.notifyUser("A passcode has not been set",
                                    err: authError?.localizedDescription)
                    UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)

                default:
                    self.notifyUser(self.touchIdNotAvailable, err: self.errorMsg)
                }
            } else {
                print("ios 10 or less than")
                switch authError!.code{

                case LAError.Code.touchIDNotEnrolled.rawValue:
                    UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)

                case LAError.Code.passcodeNotSet.rawValue:
                    self.notifyUser("A passcode has not been set",
                                    err: authError?.localizedDescription)
                    UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)

                default:
                    self.notifyUser(self.touchIdNotAvailable, err: self.errorMsg)
                }
            }
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: okay, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func enableTouchIdAlert(_ msg: String, err: String?){
        let alert = UIAlertController(title: msg, message: err, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES" , style: .default, handler: { (action) -> Void in
            self.authenticationUsingTouchID()
          
        })
        let cancelAction = UIAlertAction(title: "SKIP", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

