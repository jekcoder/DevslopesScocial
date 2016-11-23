//
//  FeedVC.swift
//  DevslopesSocial
//
//  Created by John Kine on 2016-11-23.
//  Copyright © 2016 John Kine. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    

    @IBAction func signOutTapped(_ sender: Any) {
        
      KeychainWrapper.standard.removeObject(forKey: KEY_UID)
      try! FIRAuth.auth()?.signOut()
      dismiss(animated: true, completion: nil)
        
    }

}
