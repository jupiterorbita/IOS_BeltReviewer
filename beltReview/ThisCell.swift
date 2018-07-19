//
//  ThisCell.swift
//  beltReview
//
//  Created by J on 7/18/2018.
//  Copyright © 2018 J. All rights reserved.
//
// ====== THIS CELL VC ===== CELL
import UIKit

protocol ThisCellDelegate: class {
    func buttonChecked(from sender: ThisCell, indexPath: IndexPath)
}

class ThisCell: UITableViewCell{

    var delegate: ThisCellDelegate! // <- always!!(!)
    var indexPathThisCell: IndexPath!
    
    // buttonChecked Pressed IMG ---- 
    @IBAction func buttonChecked(_ sender: UIButton) {
        delegate.buttonChecked(from: self, indexPath: indexPathThisCell) // the second part indexpath
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateCellLabel: UILabel!
    
    @IBOutlet weak var buttonCellOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
