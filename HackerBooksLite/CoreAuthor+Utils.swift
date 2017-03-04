import CoreData

extension CoreAuthor {
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<CoreAuthor> {
        
        let fetchRequest: NSFetchRequest<CoreAuthor> = CoreAuthor.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "fullName", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    class func uniqueObjectWithValue(fullName: String, context: NSManagedObjectContext) -> CoreAuthor? {
        
        let fetchRequest: NSFetchRequest<CoreAuthor> = CoreAuthor.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "fullName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "fullName", fullName)
        
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
