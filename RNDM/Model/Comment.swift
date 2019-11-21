//
//  Comment.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var commentTxt: String!
    private(set) var userId: String!
    private(set) var documentId: String!

    
    
    init(username: String, timestamp: Date, commentTxt: String, userId: String, documentId: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentTxt = commentTxt
        self.userId = userId
        self.documentId = documentId
    }
    
    
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments  = [Comment]()
        guard let snap = snapshot else { return comments }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anon"
            let timestamp: Timestamp = data [TIMESTAMP] as? Timestamp ?? Timestamp()
            let date: Date = timestamp.dateValue()
            let commentTxt = data[COMMENT_TXT] as? String ?? ""
            let userId = data[USER_ID] as? String ?? ""
            let documentId = document.documentID
            
            
            
            let newcomment = Comment(username: username, timestamp: date, commentTxt: commentTxt, userId: userId, documentId: documentId)
            comments.append(newcomment)
        }
        return comments
    }
}

