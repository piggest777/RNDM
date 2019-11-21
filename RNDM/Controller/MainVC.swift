//
//  MainVC.swift
//  RNDM
//
//  Created by Denis Rakitin on 2019-05-12.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

enum ThoughtCategory : String {
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ThoughtDelegate {
   

    //Outlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    //var
    private var thoughts = [Thought]()
    private lazy var thoughtsCollectionRef: CollectionReference = Firestore.firestore().collection(THOUGHTS_REF)
    private var thoughtsListiner: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    private var handle: AuthStateDidChangeListenerHandle?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
                self.present(loginVC, animated: false, completion: nil)
            } else {
                self.setListener()
            }
        })
        
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListiner != nil {
            thoughtsListiner.remove()
        }
        
    }
    
    func thoughtOptionsTapped(thought: Thought) {
       let alert = UIAlertController(title: "Delete thought", message: "Here you can delete thoughts", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete thought", style: .default) { (action) in
            
            Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).delete(completion: { (error) in
                if let error = error {
                    debugPrint("Unable to delete thought \(error.localizedDescription)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        let editAction = UIAlertAction(title: "Edit Post", style: .default) { (action) in
            self.performSegue(withIdentifier: "toUpdatePost", sender: thought)
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
   
    

    
    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        
        thoughtsListiner.remove()
        setListener()
        
    }
    
    func setListener () {
        
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtsListiner = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error {
                        debugPrint("error fetching docs: \(error)")
                    } else {
                        self.thoughts.removeAll()
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                       
                        self.tableView.reloadData()
                    }
            }
        } else {
        
        thoughtsListiner = thoughtsCollectionRef
            .whereField(CATEGORY, isEqualTo: selectedCategory)
            .order(by: TIMESTAMP, descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                debugPrint("error fetching docs: \(error)")
            } else {
                self.thoughts.removeAll()
               self.thoughts = Thought.parseData(snapshot: snapshot)
                self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row], delegate: self)
               return cell
        } else {
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        } else if segue.identifier == "toUpdatePost"{
                if let destinationVC = segue.destination as? UpdatePostVC {
                    if let thought = sender as? Thought {
                        destinationVC.thought = thought
                    }
            }
        }
    }
    
    
    
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            debugPrint(signOutError)
        }
    }


}

