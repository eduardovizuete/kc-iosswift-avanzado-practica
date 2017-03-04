//
//  CoreBookCell.swift
//  HackerBooksLite
//
//  Created by usuario on 3/2/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import UIKit

class CoreBookCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var _coreBook: CoreBook? = nil
    
    var coreBook: CoreBook {
        
        get {
            return _coreBook!
        }
        
        set {
            _coreBook = newValue
            
            titleLabel.text = newValue.title
            
            //if let n = newValue.notes?.count {
                //numberNotesLabel.text = "\( n ) notes"
            //}
            
        }
    }

    
}
