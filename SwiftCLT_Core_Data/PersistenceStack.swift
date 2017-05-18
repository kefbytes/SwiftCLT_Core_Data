//
//  PersistenceStack.swift
//  SwiftCLT_Core_Data
//
//  Created by Franks, Kent on 5/16/17.
//  Copyright © 2017 Franks, Kent. All rights reserved.
//

import Foundation

import Foundation
import CoreData

class PersistenceStack {
    
    static let sharedStack = PersistenceStack()
    
    lazy var mainMoc: NSManagedObjectContext = {
        let moc = self.persistentContainer.viewContext
        moc.automaticallyMergesChangesFromParent = true
        return moc
    }()
    
    lazy var privateMoc: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SwiftCLT")
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(error._userInfo)")
                self?.errorHandler(error: error)
            }
        })
        return container
    }()
    
    func saveContext (context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func errorHandler(error: Error) {
        print("CoreData error \(error), \(error._userInfo)")
    }
    
    
}
