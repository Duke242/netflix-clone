
import Foundation
import CoreData
import UIKit

// Define custom error types for database operations
enum DatabaseError: Error {
    case failedToSaveData
    case failedToFetchData
    case failedToDeleteData
}

// DataPersistenceManager class to handle Core Data operations
class DataPersistenceManager {
    // Singleton instance for global access
    static let shared = DataPersistenceManager()
    
    // Function to download and save a title to Core Data
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Get the AppDelegate to access Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Get the managed object context
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new TitleItem (Core Data entity)
        let item = TitleItem(context: context)
        
        // Populate the TitleItem with data from the model
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        // Attempt to save the context and handle the result
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    // Function to fetch all saved titles from Core Data
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        // Get the AppDelegate to access Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Get the managed object context
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for TitleItem entities
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        // Attempt to fetch the titles and handle the result
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    // Function to delete a specific title from Core Data
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        
        // Get the AppDelegate to access Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // Get the managed object context
        let context = appDelegate.persistentContainer.viewContext
        
        // Delete the specified model from the context
        context.delete(model)
        
        // Attempt to save the context after deletion and handle the result
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
