//
//  CommentsVC.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase


protocol CommentDelegate {
    func commentOptionsTapped(comment: Comment)
}

class CommentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentDelegate  {
    

    

//    Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTxt: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    
    
    
    //    var
    var thought: Thought!
    var comments: [Comment] = [Comment]()
    var thoughtRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var commentListener: ListenerRegistration!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        thoughtRef = firestore.collection(THOUGHTS_REF).document(thought.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        } else {
            username = "anounimus"
        }
        
        self.view.bindToKeyboard()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentListener = firestore.collection(THOUGHTS_REF).document(self.thought.documentId)
            .collection(COMMENTS_REF)
            .order(by: TIMESTAMP, descending: false)
            .addSnapshotListener({ (snapshot, error) in
                guard let snapshot = snapshot else {
                    debugPrint("Error fetching comments: \(String(describing: error))")
                    return
                }
                self.comments.removeAll()
                self.comments = Comment.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        commentListener.remove()
    }
    
    func commentOptionsTapped(comment: Comment) {
        let alert = UIAlertController(title: "Edit comment", message: "You can delete or edit", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete comment", style: .default) { (action) in
            
            
//            self.firestore.collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF).document(comment.documentId).delete(completion: { (error) in
//                if let error = error
//                {
//                    debugPrint("Unable to delete comment \(error.localizedDescription)")
//                } else {
//                    alert.dismiss(animated: true, completion: nil)
//                }
//            })
            
            
            self.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
                
                let thoughtDocument: DocumentSnapshot
                
                do {
                    try thoughtDocument = transaction.getDocument(Firestore.firestore()
                        .collection(THOUGHTS_REF).document(self.thought.documentId))
                } catch let error as NSError {
                    
                    debugPrint("FetchError: \(error)")
                    return nil
                }
                
                guard let oldNumComments = thoughtDocument.data()?[NUM_COMMENTS] as? Int else {return nil}
                
                transaction.updateData([NUM_COMMENTS : oldNumComments - 1], forDocument: self.thoughtRef)
                
                let commentRef = self.firestore.collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF).document(comment.documentId)
                
                transaction.deleteDocument(commentRef)
                

                
                return nil
            }) { (object, error) in
                if let error = error {
                    debugPrint("Transaction failed: \(error)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        let editAction = UIAlertAction(title: "Edit comment", style: .default) { (action) in
            self.performSegue(withIdentifier: "toEditComment", sender: (comment, self.thought))
            alert.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UpdateCommentVC {
            if let commentData = sender as? (comment: Comment, thought: Thought){
                destination.commentData = commentData
                
            }
        }
    }

    @IBAction func addCommentBtnPressed(_ sender: Any) {
        guard let commentTxt = addCommentTxt.text else {return}
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let thoughtDocument: DocumentSnapshot
            
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore()
                    .collection(THOUGHTS_REF).document(self.thought.documentId))
            } catch let error as NSError {
                
                debugPrint("FetchError: \(error)")
                return nil
            }
            
            guard let oldNumComments = thoughtDocument.data()?[NUM_COMMENTS] as? Int else {return nil}
            
            transaction.updateData([NUM_COMMENTS : oldNumComments + 1], forDocument: self.thoughtRef)
            
            let newCommentRef = self.firestore.collection(THOUGHTS_REF).document(self.thought.documentId).collection(COMMENTS_REF).document()
            
            transaction.setData([
                COMMENT_TXT : commentTxt,
                TIMESTAMP : FieldValue.serverTimestamp(),
                USERNAME : self.username!,
                USER_ID : Auth.auth().currentUser?.uid ?? ""
                ], forDocument: newCommentRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.addCommentTxt.text = ""
                self.addCommentTxt.resignFirstResponder()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            
            cell.configureCell(comment: comments[indexPath.row], delegate: self)
            return cell
            
        } else {
            return UITableViewCell()
        }
        

    }
    

}
