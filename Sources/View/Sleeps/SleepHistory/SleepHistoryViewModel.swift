import Foundation
import CoreData

final class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [Sleep]()
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
    
    func fetchSleepSessions() {
        let fetchRequest: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Sleep.startDate, ascending: false)]
        
        do {
            sleepSessions = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error when trying to get sleep sessions: \(error)")
        }
    }
    
    func reload() {
        fetchSleepSessions()
    }
}
