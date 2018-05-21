//
//  LeftSidePanelVC.swift
//  uberclone
//
//  Created by Ryan Chingway on 5/20/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAccountTypeLabel: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var loginOutButton: UIButton!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var pickupModeLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickupModeSwitch.isOn = false
        pickupModeSwitch.isHidden = true
        pickupModeLabel.isHidden = true
        
        observePassengersAndDrivers()
        
        if Auth.auth().currentUser == nil {
            userEmailLabel.isHidden = true
            userImageView.isHidden = true
            userAccountTypeLabel.isHidden = true
            loginOutButton.setTitle("Sign Up/Login", for: .normal)
            
        } else {
            userEmailLabel.isHidden = false
            userEmailLabel.text = Auth.auth().currentUser?.email
            userAccountTypeLabel.text = ""
            userImageView.isHidden = false
            loginOutButton.setTitle("Logout", for: .normal)
        }
        
        
    }
    
    func observePassengersAndDrivers() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLabel.text = "PASSENGER"
                        self.userAccountTypeLabel.isHidden = false
                        
                        self.userEmailLabel.isHidden = false
                        self.userEmailLabel.text = Auth.auth().currentUser?.email
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLabel.text = "DRIVER"
                        self.userAccountTypeLabel.isHidden = false
                        
                        self.pickupModeSwitch.isHidden = false
                        let switchStatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool
                        self.pickupModeSwitch.isOn = switchStatus
                        
                        self.userEmailLabel.isHidden = false
                        self.userEmailLabel.text = Auth.auth().currentUser?.email
                        
                        self.pickupModeLabel.isHidden = false
                        print("Now I see it")
                    }
                }
            }
        })
    }
    
    @IBAction func pickupSwitchValueChanged(_ sender: Any) {
        if pickupModeSwitch.isOn {
            pickupModeLabel.text = "PICKUP MODE ENABLED"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled" : true])
        } else {
            pickupModeLabel.text = "PICKUP MODE DISABLED"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled" : false])
        }
    }
    
    
    @IBAction func signUpLoginPressed(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
            present(loginVC!, animated: true, completion: nil)
        } else {
            
            do {
               try Auth.auth().signOut()
                pickupModeSwitch.isHidden = true
                userImageView.isHidden = true
                pickupModeLabel.text = ""
                userAccountTypeLabel.text = ""
                userEmailLabel.text = ""
                userEmailLabel.isHidden = true
                loginOutButton.setTitle("Sign Up/Login", for: .normal)
                
            } catch (let error) {
                print(error)
            }
            
        }
    }
}
