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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
            }
        })
        
    }


}

