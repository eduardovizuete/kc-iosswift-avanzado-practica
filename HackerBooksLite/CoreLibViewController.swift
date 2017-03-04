//
//  CoreLibViewController.swift
//  HackerBooksLite
//
//  Created by usuario on 3/2/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import UIKit
import CoreData

class CoreLibViewController: UIViewController {

    var context: NSManagedObjectContext?
    
    var _fetchedResultsController: NSFetchedResultsController<CoreBook>? = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
