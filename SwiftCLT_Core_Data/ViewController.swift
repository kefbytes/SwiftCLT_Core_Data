//
//  ViewController.swift
//  SwiftCLT_Core_Data
//
//  Created by Franks, Kent on 5/16/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountUserNameTextField: UITextField!
    @IBOutlet weak var accountPasswordTextField: UITextField!
    
    let persistenceStack = PersistenceStack.sharedStack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccount()
    }
    
    func fetchAccount() {
        
        let accountRequest = NSFetchRequest<Account>(entityName: "Account")
        do {
            let items = try persistenceStack.mainMoc.fetch(accountRequest)
            for account in items {
                print("🤖 accountName = \(account.accountName!)")
                print("🤖 username = \(account.accountUserName!)")
                print("🤖 password = \(account.accountPassword!)")
            }
        } catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }

    }


    // MARK: - Actions
    
    @IBAction func saveAction(_ sender: Any) {
        
        // Saving using the privateMoc
        let account = Account(context: persistenceStack.privateMoc)
        account.accountName = accountNameTextField.text
        account.accountUserName = accountUserNameTextField.text
        account.accountPassword = accountPasswordTextField.text
        
        persistenceStack.saveContext(context: persistenceStack.privateMoc)
        
//        // Saving using the temp Moc
//        persistenceStack.persistentContainer.performBackgroundTask { (context) in
//          let account = Account(context: context)
//         account.accountName = self.accountNameTextField.text
//            account.accountUserName = self.accountUserNameTextField.text
//            account.accountPassword = self.accountPasswordTextField.text
//            self.persistenceStack.saveContext(context: context)
//        }
        
        accountNameTextField.text = ""
        accountUserNameTextField.text = ""
        accountPasswordTextField.text = ""

    }
    
}

