import CoreData

extension CoreTag {
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<CoreTag> {
        
        let fetchRequest: NSFetchRequest<CoreTag> = CoreTag.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    class func uniqueObjectWithValue(name: String, context: NSManagedObjectContext) -> CoreTag? {
        
        let fetchRequest: NSFetchRequest<CoreTag> = CoreTag.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "name", name)
        
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
