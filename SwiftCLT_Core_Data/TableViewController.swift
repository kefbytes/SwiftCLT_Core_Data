//
//  TableViewController.swift
//  SwiftCLT_Core_Data
//
//  Created by Franks, Kent on 5/16/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    @IBOutlet var accountsTableView: UITableView!
    
    private let persistentContainer = NSPersistentContainer(name: "SwiftCLT")
    let persistenceStack = PersistenceStack.sharedStack
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Account> = {
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "accountName", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistenceStack.mainMoc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsTableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError   
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
}

// MARK: - ViewController Extension

extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accounts = fetchedResultsController.fetchedObjects else { return 0 }
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"accountCell", for: indexPath) as UITableViewCell
        
        // Fetch Quote
        let account = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        cell.textLabel?.text = account.accountName
        cell.detailTextLabel?.text = account.accountUserName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Account
            let song = fetchedResultsController.object(at: indexPath)
            
            // Delete Quote
            song.managedObjectContext?.delete(song)
        }
    }
}

extension TableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        accountsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        accountsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                accountsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                accountsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
}


