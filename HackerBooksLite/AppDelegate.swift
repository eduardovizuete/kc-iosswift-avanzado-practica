//
//  AppDelegate.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 7/12/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    var context: NSManagedObjectContext?
    
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize core data manager
        let container = persistentContainer(dbName: "HackerBooksLite") { (error: NSError) in
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        // Download data from json and save in model core data
        downloadDataBooksFromJson(container: container.viewContext)
        
        self.context = container.viewContext
        
        injectContextToFirstViewController()
        
        return true
    }
    
    func injectContextToFirstViewController() {
        if let navController = window?.rootViewController as? UINavigationController,
            let initialViewController = navController.topViewController as? CoreLibViewController
        {
            initialViewController.context = self.context
        }
    }
    
    func downloadDataBooksFromJson(container: NSManagedObjectContext) {
        // Clean up all local caches
        AsyncData.removeAllLocalFiles()
        
        // Create the model
        do{
            guard let url = Bundle.main.url(forResource: "books_readable", withExtension: "json") else{
                fatalError("Unable to read json file!")
            }
            
            let data = try Data(contentsOf: url)
            let jsonDicts = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONArray
            
            let books = try decode(books: jsonDicts)
            loadBooksIntoModelCoreData(bookList: books, context: container)
        }catch {
            fatalError("Error while loading model")
        }

    }
    
    private func loadBooksIntoModelCoreData(bookList: [Book], context: NSManagedObjectContext){
        
        for book in bookList{
            let uniqueObj = CoreBook.uniqueObjectWithValue(title: book.title, context: context)
            
            if (uniqueObj == nil) {
                let coreBook = CoreBook(context: context)
                //notebook.creationDate = NSDate()
                coreBook.title = book.title
                
                // llenar a bd author
                for aut in book._authors {
                    let uniqueObjAut = CoreAuthor.uniqueObjectWithValue(fullName: aut, context: context)
                    
                    if (uniqueObjAut == nil) {
                        let coreAuthor = CoreAuthor(context: context)
                        coreAuthor.fullName = aut
                        coreBook.addToAuthors(coreAuthor)
                    }
                }
                
                // llenar a bd tags y booktags
                for tag in book.tags {
                    
                    let uniqueObjTag = CoreTag.uniqueObjectWithValue(name: tag._name, context: context)
                   
                    if (uniqueObjTag == nil) {
                        let coreTag = CoreTag(context: context)
                        coreTag.name = tag._name
                    }
                    
                    let nameBookTag = "[" + book.title + "]" + "[" + tag._name + "]"
                    let uniqueObjBookTag = CoreBookTag.uniqueObjectWithValue(name: nameBookTag, context: context)
                    
                    if (uniqueObjBookTag == nil) {
                        let coreBookTag = CoreBookTag(context: context)
                        coreBookTag.name = nameBookTag
                        coreBook.addToBookTags(coreBookTag)
                    }
                }
                
                // llenar a bd pdf
                let corePDF = CorePDF(context: context)
                corePDF.urlString = book._pdf.url.description
                corePDF.data = book._pdf.data as NSData?
                
                // llenar a bd BookCoverPhoto
                let coreBCPhoto = CoreBookCoverPhoto(context: context)
                coreBCPhoto.remoteURLString = book._image.url.description
                coreBCPhoto.data = book._image.data as NSData?
                
                saveContext(context: context)
                print("Insertando objeto coreBook: %@", coreBook )
            }
        }
        
        saveContext(context: context)
    }

}

