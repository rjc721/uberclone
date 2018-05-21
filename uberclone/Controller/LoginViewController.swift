//
//  LoginViewController.swift
//  uberclone
//
//  Created by Ryan Chingway on 5/20/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: RoundedCornerTextField!
    @IBOutlet weak var passwordField: RoundedCornerTextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var signUpButton: RoundedShadowButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        if emailField.text != nil && passwordField.text != nil {
            signUpButton.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                   
                    if error == nil {
                        if let user = user {
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider" : user.providerID] as [String : Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            } else {
                                let userData = ["provider" : user.providerID, "userIsDriver" : true, "isPickupModeEnabled" : false, "driverIsOnTrip" : false] as [String : Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                            case .wrongPassword:
                                print("Incorrect password")
                            default:
                                print("An unexpected error occurred.")
                            }
                        }
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                    switch errorCode {
                                    case .invalidEmail:
                                        print("Incorrect password")
                                    default:
                                        print("An unexpected error occurred.")
                                    }
                                }
                            } else {
                                
                                if let user = user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider" : user.providerID] as [String : Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider" : user.providerID, "userIsDriver" : true, "isPickupModeEnabled" : false, "driverIsOnTrip" : false] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                print("successfully created driver")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                    
                    
                }
            }
        }
    }
    
}
