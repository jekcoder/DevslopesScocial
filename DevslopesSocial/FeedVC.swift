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
              UINavigationControllerDelegate, UITextFieldDelegate  {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!
    
    
    var posts = [Post]()
    var imagePicker:UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        captionField.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
        
            self.posts = []
            
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
        
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                
                cell.configureCell(post: post, img:img)
                
            } else {
                
                cell.configureCell(post: post)
                
            }
 
            return cell
            
        } else {
            
            return PostCell()
        }
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            imageSelected = true
            
        } else {
            
            print("John: a vild image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addimageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else {
            
            print("John: Caption must be entered")
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            
            print("John: An image must be selected")
            return
        }
        
        if captionField.isFirstResponder {
            
            captionField.resignFirstResponder()
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData,metadata: metadata) { (metadata, error) in
                
                
                if error != nil {
                    
                    print("John: Unable to upload to Firebase")
                    
                } else {
                    
                    print("John: Sucessfully uploaded image to Firebase")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                    }
                }
            }
        }
    }
    
    
    func postToFirebase(imageUrl: String) {
        
        let post: Dictionary<String, AnyObject> = [
        
        "caption":captionField.text as AnyObject,
        "imageUrl":imageUrl as AnyObject,
        "likes":0 as AnyObject
        ]
            
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        self.captionField.text = ""
        self.imageSelected = false
        self.imageAdd.image = UIImage(named: "add-image")
        tableView.reloadData()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        
      KeychainWrapper.standard.removeObject(forKey: KEY_UID)
      try! FIRAuth.auth()?.signOut()
      dismiss(animated: true, completion: nil)
        
    }

}
