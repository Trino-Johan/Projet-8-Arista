import CoreData
import Foundation

struct SleepRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
            self.viewContext = viewContext
        }
    
    func getSleepSessions() throws -> [Sleep] {
        let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        // pas de fetchLimit pour obtenir toutes les sessions
        // tri avec sortDescriptor
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        return try viewContext.fetch(request)
    }
    
    func addSleepSession(startDate: Date, duration: Int, quality: Int) throws {
        let sleepSession = Sleep(context: viewContext)
        sleepSession.startDate = startDate
        sleepSession.duration = Int64(duration)
        sleepSession.quality = Int64(quality)
        
        // Debug, user trouvé ?
        if let user = try? UserRepository(viewContext: viewContext).getUser() {
            print("Utilisateur trouvé: \(user.firstName ?? "?")")
            sleepSession.user = user
        } else {
            print("ERREUR : Aucun utilisateur trouvé !")
            throw NSError(domain: "ExerciseRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Aucun utilisateur trouvé"])
        }
        
        try viewContext.save()
    }
}
