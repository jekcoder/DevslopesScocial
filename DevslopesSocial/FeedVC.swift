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

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate,
              UINavigationControllerDelegate  {

    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var imageAdd: CircleView!
    
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
        
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("Snap: \(snap)")
                    if let postDic = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDic)
                        self.posts.append(post)
                        
                    }
                }
                
            }
            self.tableView.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.configureCell(post: posts[indexPath.row])
            return cell
            
        } else {
            
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
        } else {
            print("John: a vild image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addimageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
      KeychainWrapper.standard.removeObject(forKey: KEY_UID)
      try! FIRAuth.auth()?.signOut()
      dismiss(animated: true, completion: nil)
        
    }

}
