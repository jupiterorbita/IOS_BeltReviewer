//
//  ShowVC.swift
//  beltReview
//
//  Created by J on 7/18/2018.
//  Copyright © 2018 J. All rights reserved.
//
// *********  SHOW VC ***********
import UIKit
import CoreData // or this

class ShowVC: UIViewController {

    
    var note: Note?
    
    
    @IBOutlet weak var titleLabelShowVC: UILabel!
    @IBOutlet weak var dateLabelShowVC: UILabel!
    @IBOutlet weak var noteLabelShowVC: UITextView!
    
    
    //create these so theat they are accessible
    
    var titleShow: String = ""
    var noteShow: String = ""
    var dateShow: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting the vars from the prepare segue Main VC
        
        titleLabelShowVC.text = titleShow
        dateLabelShowVC.text = dateShow
        noteLabelShowVC.text = noteShow
        
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
