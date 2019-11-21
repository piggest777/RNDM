//
//  FirebaseConfig.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-14.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: NSObject {
    static let shared = FirebaseService()
    
    override init() {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
}
