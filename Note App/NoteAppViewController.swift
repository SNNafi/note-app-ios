//
//  NoteAppViewController.swift
//  Note App
//
//  Created by Shahriar Nasim Nafi on 9/10/20.
//  Copyright © 2020 Shahriar Nasim Nafi. All rights reserved.
//

import UIKit
import CoreData

class NoteAppViewController: UITableViewController {
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest = NSFetchRequest<Note>()
        let entity = Note.entity()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 30
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: "Notes")
        fetchedResultsController.delegate = self
        return fetchedResultsController
        
        
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)[0])
        
        let noteListNib = UINib(nibName:Constant.noteListCellIdentifier , bundle: nil)
        tableView.register(noteListNib, forCellReuseIdentifier: Constant.noteListCellIdentifier)
        
        performFetch()
        
        //  self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.noteListCellIdentifier, for: indexPath) as! NoteList
        cell.setUpNote(for: note)
        // cell.editNote.addTarget(self, action: #selector(editNote(_:)), for: .touchUpInside)
        // cell.editNote.select(indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "EditNote", sender: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        context.delete(note)
        do{
            try context.save()
        }catch{
            fatalError("\(error.localizedDescription)")
        }
    }
    
    
}


extension NoteAppViewController: NSFetchedResultsControllerDelegate {
    
    func performFetch(){
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Error: \(error)")
        }
    }
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerWillChangeContent")
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = tableView.cellForRow(at: indexPath!) as? NoteList{
                let note = fetchedResultsController.object(at: indexPath!)
                cell.setUpNote(for: note)
            }
            
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        @unknown default:
            fatalError("Unhandled switch case ofNSFetchedResultsChangeType")
        }
        
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        @unknown default:
            fatalError("Unhandled switch case of NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}


//MARK: - Navigation

extension NoteAppViewController{
    
    @objc func editNote(_ sender: IndexPath){
        performSegue(withIdentifier: "EditNote", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNote" {
            let destination = segue.destination as! AddEditNote
            destination.noteForEdit = fetchedResultsController.object(at: (sender as! IndexPath))
        }
    }
}
