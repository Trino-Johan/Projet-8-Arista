import CoreData
import Foundation

struct UserRepository {
    let viewContext: NSManagedObjectContext // pont vers la bdd CoreData
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
            self.viewContext = viewContext
        }
    
    func getUser() throws -> User? {// throw pour une erreur potentielle
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1 // recupere un seul user
        return try viewContext.fetch(request).first
    }
}

