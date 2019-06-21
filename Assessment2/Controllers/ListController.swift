//
//  ListController.swift
//  Assessment2
//
//  Created by Leah Cluff on 6/21/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    
    static let sharedInstance = ListController()
    
    var fetchedResultsController: NSFetchedResultsController<List>
    
    init() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true)]
        
        let resultsController: NSFetchedResultsController<List> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        fetchedResultsController = resultsController
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            print("error performing fetch")
        }
    }
    
    func create(itemName: String){
        let createItem = List(item: itemName)
        saveToPersistentStore()
    }
    
    func update(list: List, item: String){
        list.item = item
        saveToPersistentStore()
    }
    
    func remove(list: List){
        list.managedObjectContext?.delete(list)
        saveToPersistentStore()
    }
    
    func toggleIsCompleteFor(list: List) {
        list.isComplete = !list.isComplete
    }
    
    private func saveToPersistentStore() {
        
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object Context. Items not saved \(error.localizedDescription)")
        }
    }
}
