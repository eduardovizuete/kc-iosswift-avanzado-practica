import CoreData

extension CoreBookCoverPhoto {
    
    class func fetchRequestOrderedByName() -> NSFetchRequest<CoreBookCoverPhoto> {
        
        let fetchRequest: NSFetchRequest<CoreBookCoverPhoto> = CoreBookCoverPhoto.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "remoteURLString", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    class func uniqueObjectWithValue(remoteURLString: String, context: NSManagedObjectContext) -> CoreBookCoverPhoto? {
        
        let fetchRequest: NSFetchRequest<CoreBookCoverPhoto> = CoreBookCoverPhoto.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let sortDescriptor = NSSortDescriptor(key: "remoteURLString", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "remoteURLString", remoteURLString)
        
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
