//
//  Post.swift
//  DevslopesSocial
//
//  Created by John Kine on 2016-11-25.
//  Copyright © 2016 John Kine. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption:String!
    private var _userName:String!
    private var _imageUrl:String!
    private var _likes:Int!
    private var _postKey:String!
    private var _postRef:FIRDatabaseReference!
    
    var caption:String {
        
        return _caption
    }

    var userName:String {
        
        return _userName
    }
    
    var imageUrl:String {
        
        return _imageUrl
    }
    
    var likes:Int {
        
        return _likes
    }
    
    var postKey:String {
        
        return _postKey
    }
    
    init (caption: String, imageUrl: String, likes:Int) {
        
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey:String, postData: Dictionary<String, AnyObject>) {
        
        self._postKey = postKey
        
        if let caption = postData["caption"] {
            
            self._caption = caption as? String
        }
        
        if let userName = postData["userName"] {
            
            self._userName = userName as? String
        }
        
        if let imageUrl = postData["imageUrl"] {
            
            self._imageUrl = imageUrl as? String
        }
        
        if let likes = postData["likes"] {
            
            self._likes = likes as? Int
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLikes: Bool) {
        
        if addLikes {
            
            _likes = _likes + 1
            
        } else if _likes > 0 {
            
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }

    
}

