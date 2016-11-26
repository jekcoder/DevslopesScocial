//
//  Post.swift
//  DevslopesSocial
//
//  Created by John Kine on 2016-11-25.
//  Copyright © 2016 John Kine. All rights reserved.
//

import Foundation

class Post {
    
    private var _caption:String!
    private var _imageUrl:String!
    private var _likes:Int!
    private var _postKey:String!
    
    var caption:String {
        
        return _caption
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
        
        if let imageUrl = postData["imageUrl"] {
            
            self._imageUrl = imageUrl as? String
        }
        
        if let likes = postData["likes"] {
            
            self._likes = likes as? Int
        }
        
        
    }
}

