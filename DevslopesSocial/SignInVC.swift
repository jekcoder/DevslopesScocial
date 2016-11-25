//
//  SignInVC.swift
//  DevslopesSocial
//
//  Created by John Kine on 2016-11-21.
//  Copyright © 2016 John Kine. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper


class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pwdField: FancyField!
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        emailField.delegate = self
        pwdField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "goToFeed", sender: nil)
            
        }

    }


    @IBAction func facebookBtnTapped(_ sender: RoundButton) {
        
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) {(result, error) in
            
            if error != nil {
                
                print("Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("User cancelled Facebook Authentication")
                
            } else {
                
                print("Successfully authentiction with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    
    func firebaseAuth(_ credential: FIRAuthCredential)  {
   
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                
                print("Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("Successfully authentiction with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid,userData: userData)
                }
            }
        })
    }

    @IBAction func signInTapped(_ sender: FancyButton) {
        
        self.view.frame.origin.y = 0
        
        activeTextField.resignFirstResponder()
        
        if let email = emailField.text, let pwd = pwdField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                
                if error == nil {
                    
                    print("Email user authentication with Firebase")
                    if let user = user {
                        
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData )
                    }

                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("Unable to authenticate with Firebase using email - \(error)")
                            
                        } else {
                            
                            print("Successfull authentication with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData )
                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id:String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey:KEY_UID)
        performSegue(withIdentifier: "goToFeed", sender: nil)        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        
        if textField.tag == 2 {
            
            self.view.frame.origin.y = PWD_VIEW_YPOS
            
        } else {
            
            self.view.frame.origin.y = EMAIL_VIEW_YPOS
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = VIEW_ORIGIN
        
        textField.resignFirstResponder()

        return true
    }
    
 }

