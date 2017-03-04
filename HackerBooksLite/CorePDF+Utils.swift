import CoreData

extension CorePDF {
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<CorePDF> {
        
        let fetchRequest: NSFetchRequest<CorePDF> = CorePDF.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "urlString", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    class func uniqueObjectWithValue(urlString: String, context: NSManagedObjectContext) -> CorePDF? {
        
        let fetchRequest: NSFetchRequest<CorePDF> = CorePDF.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "urlString", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "urlString", urlString)
        
        let fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResult.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Author UniqueObjectWithValue: Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        if (fetchedResult.fetchedObjects != nil) {
            return fetchedResult.fetchedObjects?.first
        } else {
            return nil
        }
    }
    
}
