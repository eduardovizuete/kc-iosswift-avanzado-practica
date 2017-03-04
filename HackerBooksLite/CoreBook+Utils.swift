import CoreData

extension CoreBook {
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<CoreBook> {
        
        let fetchRequest: NSFetchRequest<CoreBook> = CoreBook.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    class func uniqueObjectWithValue(title: String, context: NSManagedObjectContext) -> CoreBook? {
        
        let fetchRequest: NSFetchRequest<CoreBook> = CoreBook.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "title", title)
        
        let fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        do {
            try fetchedResult.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("UniqueObjectWithValue: Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        if (fetchedResult.fetchedObjects != nil) {
            return fetchedResult.fetchedObjects?.first
        } else {
            return nil
        }
        
    }

}
