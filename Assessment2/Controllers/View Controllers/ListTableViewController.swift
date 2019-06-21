//
//  ListTableViewController.swift
//  Assessment2
//FUUUUUUUUUCK
//  Created by Leah Cluff on 6/21/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewItemAlert().self
    }
    
    func presentNewItemAlert() {
        let newItemAlertController = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        
        var itemTextField = UITextField()
        newItemAlertController.addTextField { (itemName) in
            itemName.placeholder = ""
            itemTextField = itemName
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let itemName = newItemAlertController.textFields?[0].text else {return}

            ListController.sharedInstance.create(itemName: itemName)
            UIApplication.shared.applicationIconBadgeNumber = 1
           
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        newItemAlertController.addAction(saveAction)
        newItemAlertController.addAction(cancelAction)
        
        self.present(newItemAlertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return ListController.sharedInstance.fetchedResultsController.sections?.count ?? 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ListController.sharedInstance.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ButtonTableViewCell else {return UITableViewCell()}
        let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.update(withList: list)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionNumber = Int(ListController.sharedInstance.fetchedResultsController.sections?[section].name ?? "zero")
        
        if sectionNumber == 0 {
            return "Incomplete"
        } else {
            return "Complete"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
}

extension  ListTableViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender)
            else {return}
        let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        list.isComplete = !list.isComplete
        sender.update(withList: list)
    }
}

extension ListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            switch type{
            case .delete:
                guard let indexPath = indexPath else { break }
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else { break }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { break }
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            @unknown default:
                fatalError()
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            
            switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            @unknown default:
                fatalError()
            }
        }
    }
}
