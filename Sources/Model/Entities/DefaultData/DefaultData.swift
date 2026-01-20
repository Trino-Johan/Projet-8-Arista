import Foundation
import CoreData

struct DefaultData {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func apply() throws {
        let userRepository = UserRepository(viewContext: viewContext)
        let sleepRepository = SleepRepository(viewContext: viewContext)
        
        // Cree user uniquement s'il n'existe pas
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.firstName = "Johan"
            initialUser.lastName = "Trino"
            
            // Cree 5 sessions de sommeil uniquement si aucune n'existe
            if try sleepRepository.getSleepSessions().isEmpty {
                let timeIntervalForADay: TimeInterval = 60 * 60 * 24
                
                for dayOffset in 1...5 {
                    let sleep = Sleep(context: viewContext)
                    sleep.duration = Int64((0...900).randomElement()!)
                    sleep.quality = Int64((0...10).randomElement()!)
                    sleep.startDate = Date(timeIntervalSinceNow: timeIntervalForADay * Double(dayOffset))
                    sleep.user = initialUser
                }
            }
            
            try? viewContext.save()
        }
    }
}
