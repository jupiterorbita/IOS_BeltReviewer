//
//  AddEditVC.swift
//  beltReview
//
//  Created by J on 7/18/2018.
//  Copyright © 2018 J. All rights reserved.
//
//======= ADD EDIT VC ======
import UIKit

class AddEditVC: UIViewController {

    
    @IBOutlet weak var titleAddEditTextField: UITextField!
    @IBOutlet weak var noteAddEditTextView: UITextView!
    @IBOutlet weak var dateAddEditPicker: UIDatePicker!
    
    //create var to receive data from main VC to store to edit
    var titleEdit: String = ""
    var noteEdit: String = ""
    var dateEdit: Date?
    
    var editmode: Bool = false
    // make an indexPath so we can pass it back
    var indexPathAddEditVC: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateAddEditPicker.minimumDate = Date()
        if editmode == true{
            titleAddEditTextField.text = titleEdit
            noteAddEditTextView.text = noteEdit
            dateAddEditPicker.setDate(dateEdit!, animated: true)
        }
    }

    
    // cancel
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // save
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //validations before segue
        if titleAddEditTextField.text == "" || noteAddEditTextView.text == "" {
            print("EMPTY STRINGS DO NOT GO BACK 😴")
            let alert = UIAlertController(title: "Field Error ☹️", message: "Fields must be filled in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss 👍", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if dateAddEditPicker.date < Date() {
            print("must select future date")
            let alert = UIAlertController(title: "incorrect Date 📆", message: "date must be future ⏰", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss 👍", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "unwindsegueFromAddEditVC", sender: self)
        }
        
//        performSegue(withIdentifier: "unwindsegueFromAddEditVC", sender: self)
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
