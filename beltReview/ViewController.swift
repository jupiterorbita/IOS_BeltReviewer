//
//  ViewController.swift
//  beltReview
//
//  Created by J on 7/18/2018.
//  Copyright © 2018 J. All rights reserved.
//
// ========= MAIN VC ==========
import UIKit
import CoreData

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [Note] = []
    
    
    //✈️ from ADD EDIT VC SEGUE
    @IBAction func unwindsegueFromAddEditVC(segue: UIStoryboardSegue) {
        let src = segue.source as! AddEditVC
        
        let title = src.titleAddEditTextField.text!
        let note = src.noteAddEditTextView.text!
        let date = src.dateAddEditPicker.date
        print("inside --- unwind segue ------")
        
        if src.editmode == true {
            if let indexPathAddEditVC = src.indexPathAddEditVC as? IndexPath {
                let item = tableData[indexPathAddEditVC.row]
                item.title = title
                item.note = note
                item.date = date
                print("edit======== ", title, note, date)
                appDelegate.saveContext()
                tableView.reloadData()
            }
        }
        else{
//            let title = src.titleAddEditTextField.text!
//            let note = src.noteAddEditTextView.text!
//            let date = src.dateAddEditPicker.date
            print("got back with ", title, note, date)
            
            let newNote = Note(context: context)
            newNote.title = title
            newNote.note = note
            newNote.date = date
            newNote.completed = false
            
            appDelegate.saveContext()
            tableData.append(newNote)
            tableView.reloadData()
        }

    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addEditSegue", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        fetchAll()
    }

    
    //get ALL 📆
    func fetchAll() {
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        //order by date:
        let sortByDate = NSSortDescriptor(key: #keyPath(Note.date), ascending: false)
        let sortByCompleted = NSSortDescriptor(key: #keyPath(Note.completed), ascending: false)
        request.sortDescriptors = [sortByCompleted,sortByDate]
        do {
            tableData = try context.fetch(request)
        } catch {
            print("couldn't fetchAll from DB", error)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("prepareForSegue to ShowVC!")
//        if let indexPath = sender as? IndexPath{
//            if segue.identifier == "ShowSegue"{
//                let dest = segue.destination as! ShowVC
//                print("going to ShowVC through ShowSegue from prepare segue func in ViewController")
//                let note = tableData[indexPath.row]
//                dest.note = note
//                dest.indexPath = indexPath
//            }
//            else if segue.identifier == "AddEditSegue"{
//                print("going to AddEditVC as add item")
//                let nav = segue.destination as! UINavigationController
//                let dest_2 = nav.topViewController as! AddEditVC
//                let note = tableData[indexPath.row]
//                print(note)
//                dest_2.note = note
//                dest_2.indexPath = indexPath
//            }
//        }
//
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // go to del
        if let indexPath = sender as? IndexPath {
            if segue.identifier == "showSegue" {
                //grab data from tabledata
                let title = tableData[indexPath.row].title
                let note = tableData[indexPath.row].note
                let date = tableData[indexPath.row].date
                print("-----------")
                print(title, note, date)
                
                let dest = segue.destination as! ShowVC
                
                //date
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                
                dest.titleShow = title as! String
                dest.noteShow = note as! String
                dest.dateShow = formatter.string(from: date!)
            }
                //EDIT
            else if segue.identifier == "addEditSegue" && tableData[indexPath.row].completed == false {
                let nav = segue.destination as! UINavigationController
                let dest = nav.topViewController as! AddEditVC
                
                let title = tableData[indexPath.row].title
                let note = tableData[indexPath.row].note
                let date = tableData[indexPath.row].date
                
                dest.editmode = true
                dest.titleEdit = title as! String
                dest.noteEdit = note as! String
                dest.dateEdit = date!
                dest.indexPathAddEditVC = indexPath // to send the indxpath and have a value
            }
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThisCell", for: indexPath) as! ThisCell
        
        let cellData = tableData[indexPath.row]
        
        //set the cell labels in main view
        cell.titleLabel.text = tableData[indexPath.row].title
        //date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        cell.dateCellLabel.text = formatter.string(from: tableData[indexPath.row].date!)
        //set the cell delegate
        cell.delegate = self
        cell.indexPathThisCell = indexPath
        
        // change bg img for checked button
        //set the img and that was checked in the delegate

        if cellData.completed == true {
            cell.buttonCellOutlet.setBackgroundImage(UIImage(named: "check"), for: .normal)
        } else {
            cell.buttonCellOutlet.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
        }
//        // img set short way
//        let imgName = cellData.completed ? "check" : "nocheck"
//        cell.buttonCellOutlet.setBackgroundImage(UIImage(named: imgName), for: .normal)
     
        
        
        return cell
    }
    
    
    //DELETE & EDIT SWIPE ACTIONS
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //delete
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") {action, view, completetionHandler in
            
            self.context.delete(self.tableData[indexPath.row])
            self.tableData.remove(at: indexPath.row)
            self.appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completetionHandler(true)
        }
        //edit
        let note = tableData[indexPath.row]
        if note.completed == false {
            let editAction = UIContextualAction(style: .normal, title: "Edit") {action, view, completionHandler in
                
                self.performSegue(withIdentifier: "addEditSegue", sender: indexPath)
                completionHandler(false)
            }
            editAction.backgroundColor = .blue
            
            let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            return swipeConfig
        } else {
            let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipeConfig
        }
//        return swipeConfig
    }

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSegue", sender: indexPath)
    }

}


extension ViewController: ThisCellDelegate {
    func buttonChecked(from sender: ThisCell, indexPath: IndexPath) {
//        let indexPath = tableView.indexPath(for: sender)!
        if tableData[indexPath.row].completed == true {
            tableData[indexPath.row].completed = false
        } else {
            tableData[indexPath.row].completed = true
        }
        appDelegate.saveContext()

        fetchAll()
//        // short way
//        tableData[indexPath.row].completed = !tableData[indexPath.row].completed
        // or
//        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }

}









